# coding: utf-8

class Form < ActiveRecord::Base
  GROUPS = [:tg, :og, :pg, :cg]
  STATES = [:pending, :accepted, :rejected]

  bitmask :groups, :as => GROUPS
  bitmask :state, :as => (GROUPS.product(STATES).map {|s| s.join('_').to_sym}) + [:duplicated]

  GROUPS.each do |g|
    define_method(g) { groups.include? g }
    define_method("#{g}=") { |x| x != false && (x == true || x.to_i != 0) ? (groups << g) : groups.delete(g) }
  end

  validates_presence_of :name, :tel, :major, :gender, :email

  validates_presence_of :tg_q1, :tg_q2, :tg_q3, :tg_q4, :if => :tg
  validates_presence_of :og_q1, :og_q2, :og_q3, :if => :og
  validates_presence_of :pg_q1, :pg_q2, :pg_q3 , :if => :pg
  validates_presence_of :cg_q1, :cg_q2, :cg_q3, :if => :cg


  PHONE_REGEX = /\A[0-9\-+ ]+\z/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :format => { :with => EMAIL_REGEX }
  validates :gender, :inclusion => { :in => 1..2 }
  validates :campus, :inclusion => { :in => 1..2 }
  
  validates :name, :length => { :within => 2..36 }
  validates :tel, :length => { :within => 5..40 }, :format => { :with => PHONE_REGEX }

  validate :check_groups

  # attr_protected :cookie_hash

  attr_accessible :campus, :cg, :comments, :cookie_hash, :created_at, :email, :forum_id, :gender, :id, :major, :name, :og, :pg, :groups, :tel, :tg, :updated_at, :tg_q1, :tg_q2, :tg_q3, :tg_q4, :pg_q1, :pg_q2, :pg_q3, :og_q1, :og_q2, :og_q3, :cg_q1, :cg_q2, :cg_q3, :user_agent, :as => :admin
  attr_accessible :campus, :cg, :email, :forum_id, :gender, :major, :name, :og, :pg, :tg_q1, :tg_q2, :tg_q3, :tg_q4, :pg_q1, :pg_q2, :pg_q3, :og_q1, :og_q2, :og_q3, :cg_q1, :cg_q2, :cg_q3, :tel, :tg, :groups, :user_agent

  def campus_sym
    [nil, :zjg, :yq][campus]
  end

  def gender_sym
    spam ? :spam : (gender == 1 ? :male : :female)
  end

  def admin_comments(namespace = :admin)
    ActiveAdmin::Comment.find_for_resource_in_namespace(self, namespace).order('id ASC').scoped
  end

  def create_admin_comment!(author, body, namespace = :admin)
    comment = ActiveAdmin::Comment.new(body: body, resource: self, namespace: namespace)
    comment.author = author
    comment.save!
  end

  def update_state!(group, sym, staff)
    return if not staff

    if sym.nil? && group.nil?
      message   = '清除所有状态'
      new_state = []
    elsif group.nil?
      message   = "修改为 #{sym.to_s.upcase}"
      if sym.to_sym.in? STATES
        new_state = self.groups.map {|g| "#{g}_#{sym}".downcase.to_sym }
      else
        new_state = [sym.to_sym]
      end
    else
      message   = "修改 #{group.to_s.upcase} 状态为 #{sym.to_s.upcase}"
      new_state = self.state.reject{|s| s.to_s.start_with?(group.to_s)} + ["#{group.to_s}_#{sym}".downcase.to_sym]
    end

    return if new_state.sort == state.sort
    transaction do
      self.state = new_state
      self.save
      self.create_admin_comment!(staff, message, :state)
    end
  end

  # scopes
  class << self
    def nospam
      where(:spam => false).scoped
    end

    def noduplicated
      without_state(:duplicated)
    end

    STATES.each do |st|
      define_method st do
        with_any_state(*GROUPS.map{|g| "#{g}_#{st}".to_sym}).scoped
      end
    end

    def accepted
      with_any_state(*GROUPS.map{|g| "#{g}_accepted".to_sym}).scoped
    end

    def rejected
      without_state(*([:accepted, :pending].map{|st| GROUPS.map{|g| "#{g}_#{st}".to_sym}}.flatten)) \
      .with_any_state(*GROUPS.map{|g| "#{g}_rejected".to_sym}).scoped
    end

    def pending
      without_state(*([:accepted].map{|st| GROUPS.map{|g| "#{g}_#{st}".to_sym}}.flatten)) \
      .with_any_state(*GROUPS.map{|g| "#{g}_pending".to_sym}).scoped
    end

    def other
      without_state.scoped
    end

    GROUPS.each do |g|
      define_method g do
        with_any_state(*STATES.map{|st| "#{g}_#{st}".to_sym}).scoped
      end
    end
  end

  private

  def check_groups
    return if groups.size.in? 1..2

    message = groups.empty? ? '至少也得选一个吧' : '选得太多了，请少选一些'
    errors.add :groups, message
    # GROUPS.each { |g| errors.add g, message }
  end
end
