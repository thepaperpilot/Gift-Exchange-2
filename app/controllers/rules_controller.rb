class RulesController < ApplicationController
  def create
    @group = Group.find_by(code: params[:group_code])

    if @group.authenticate(params[:rule][:password])
      @rule = @group.rules.create(rule_params)
      @password = params[:rule][:password]
    end
  end

  def update
    @group = Group.find_by(code: params[:group_code])

    if @group && @group.authenticate(params[:rule][:password])
      @rule = @group.rules.find(params[:id])

      @rule.update(rule_params) if @rule
    end
  end

  def destroy
    @group = Group.find_by(code: params[:group_code])

    if @group && @group.authenticate(params[:password])
      @rule = @group.rules.find(params[:id])

      @rule.destroy if @rule
    end
  end

  private

  def rule_params
    params.require(:rule).permit(:source_match_all, :whitelist_match_all)
  end
end
