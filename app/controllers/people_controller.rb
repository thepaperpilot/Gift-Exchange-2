class PeopleController < ApplicationController
  def create
    @group = Group.find_by(code: params[:group_code])

    if current_user && current_user.id == @group.user_id
      @person = @group.people.create(person_params)
    elsif @group.open? && current_user && @group.people.none?{|person| person.user_id==current_user.id}
      @person = @group.people.create(person_params_restricted)
    end
  end

  def update
    @group = Group.find_by(code: params[:group_code])

    if current_user && (current_user.id == @group.user_id || @group.people.any?{|person|person.user_id==current_user.id})
      @person = @group.people.find(params[:id])

      @person.update(person_params) if @person
    end
  end

  def destroy
    @group = Group.find_by(code: params[:group_code])

    if current_user && (current_user.id == @group.user_id || @group.people.any?{|person|person.user_id==current_user.id})
      @person = @group.people.find(params[:id])

      @person.destroy if @person
    end
  end

  private

    def person_params
      params.require(:person).permit(:name, :family, :participating, :user_id)
    end

    def person_params_restricted
      params.require(:person).permit(:name, :user_id)
    end
end
