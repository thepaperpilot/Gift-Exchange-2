class GroupController < ApplicationController
  def show
    @group = Group.find_by(code: params[:code])
    @auth = true

    redirect_to root_path unless @group
  end

  def search
    @group = Group.find_by(code: params[:code])

    if @group
      redirect_to @group
    else
      @notfound = true
      @group = Group.new
      render 'welcome/index'
    end
  end

  def admin
    @group = Group.find_by(code: params[:code])
    @auth = false

    if @group && @group.authenticate(params[:password])
      @auth = true
      @password = params[:password]
      render 'group/admin'
    else
      render 'group/show'
    end
  end

  def randomize
    @group = Group.find_by(code: params[:code])

    return unless @group && @group.authenticate(params[:password])

    people = Person.where(group_id: @group.id)

    people.each do |person|
      person.giving_to = nil
      person.receiving_from = nil
    end

    people.each(&:save)
    participants = people.where(participating: true)
    participants_undone = participants.dup

    priority = []
    @group.rules.each do |rule|
      participants.each do |person|
        priority << person if rule.check_source(person)
      end
    end

    priority = priority.uniq

    priority.each do |person|
      receptors = participants_undone.dup - [person]
      unless person.receiving_from.nil?
        receptors -= [Person.find(person.receiving_from)]
      end
      person.apply_rules(receptors, @group.rules)
      
      next if receptors.empty?
      receptor = receptors.sample
      next if receptor.nil?
      person.giving_to = receptor.id
      participants.find { |s| s.id == receptor.id }.receiving_from = person.id
      participants_undone -= [receptor]
    end

    (participants).each do |person|
      next if person.giving_to != nil
      receptors = participants_undone.dup - [person]
      if !person.receiving_from.nil? && (receptors - [Person.find(person.receiving_from)]).length != 0
        receptors -= [Person.find(person.receiving_from)]
      end
      receptor = receptors.sample
      next if receptor.nil?
      person.giving_to = receptor.id
      participants.find { |s| s.id == receptor.id }.receiving_from = person.id
      participants_undone -= [receptor]
    end

    unless participants_undone.empty?
      puts("Oh no! Couldn't generate everyone! Fix this!")
    end

    participants.each(&:save)
  end

  def clear
    @group = Group.find_by(code: params[:code])

    return unless @group && @group.authenticate(params[:password])

    @group.people.each { |p| p.giving_to = p.receiving_from = nil }
    @group.people.each(&:save)
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to admin_path(@group)
    else
      render 'welcome/index'
    end
  end

  def update
    @group = Group.find_by(code: params[:code])

    if @group && @group.authenticate(params[:group][:password])
      @group.update(group_params)
    end
  end

  def destroy
    @group = Group.find_by(code: params[:code])

    @group.destroy if @group && @group.authenticate(params[:password])

    redirect_to root_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :password, :instructions)
  end
end
