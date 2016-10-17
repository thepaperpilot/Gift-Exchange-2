class PeopleController < ApplicationController
  def create
    @group = Group.find_by(code: params[:group_code])
    @person = @group.people.create(person_params)

    if @group.authenticate(params[:person][:password])
      @password = params[:person][:password]
      respond_to do |format|
        format.js { render file: 'people/admin.js.erb' }
      end
    end
  end

  def update
    @group = Group.find_by(code: params[:group_code])

    if @group && @group.authenticate(params[:person][:password])
      @person = @group.people.find(params[:id])

      @person.update(person_params) if @person
    end
  end

  def destroy
    @group = Group.find_by(code: params[:group_code])

    if @group && @group.authenticate(params[:password])
      @person = @group.people.find(params[:id])

      @person.destroy if @person
    end
  end

  private

  def person_params
    params.require(:person).permit(:name, :family, :participating)
  end
end