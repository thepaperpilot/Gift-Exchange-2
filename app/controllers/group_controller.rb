class GroupController < ApplicationController
  def show
    @group = Group.find_by(code: params[:code])
    @auth = true

    redirect_to root_path unless @group

    if current_user && current_user.id == @group.user_id
      render 'group/admin'
    else
      render 'group/show'
    end
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

  def randomize
    @group = Group.find_by(code: params[:code])

    return unless @group && current_user && current_user.id == @group.user_id

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
      person.apply_rules(receptors, @group.rules)
      if !person.receiving_from.nil? && (receptors - [Person.find(person.receiving_from)]).length != 0
        receptors -= [Person.find(person.receiving_from)]
      end
      
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

    return unless @group && current_user && current_user.id == @group.user_id

    @group.people.each { |p| p.giving_to = p.receiving_from = nil }
    @group.people.each(&:save)
  end

  def duplicate
    if not Group.find_by(code: params[:code])
      return
    end

    @group = Group.find_by(code: params[:code]).dup

    if @group.save
      redirect_to group_path(@group)
    else
      render 'users/show'
    end
  end

  def create
    if not logged_in?
      redirect_to root_path
      return
    end

    @user = current_user
    @group = @user.groups.build(group_params)

    if @group.save
      redirect_to group_path(@group)
    else
      render 'users/show'
    end
  end

  def update
    @group = Group.find_by(code: params[:code])

    if @group && current_user && current_user.id == @group.user_id
      @group.update(group_params)
    end
  end

  def destroy
    @group = Group.find_by(code: params[:code])

    if @group && current_user && current_user.id == @group.user_id
      @group.destroy 
      redirect_to current_user
    end
  end

  private

    def group_params
      params.require(:group).permit(:name, :instructions, :open, :public)
    end
end
