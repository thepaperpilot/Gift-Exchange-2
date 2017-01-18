class RulesController < ApplicationController
  def create
    @group = Group.find_by(code: params[:group_code])

    if current_user && current_user.id == @group.user_id
      @rule = @group.rules.create(rule_params)
    end
  end

  def update
    @group = Group.find_by(code: params[:group_code])

    if current_user && current_user.id == @group.user_id
      @rule = @group.rules.find(params[:id])

      @rule.update(rule_params) if @rule
    end
  end

  def destroy
    @group = Group.find_by(code: params[:group_code])

    if current_user && current_user.id == @group.user_id
      @rule = @group.rules.find(params[:id])

      @rule.destroy if @rule
    end
  end

  private

    def rule_params
      params.require(:rule).permit(:name, :source_match_all, :whitelist_match_all)
    end
end
