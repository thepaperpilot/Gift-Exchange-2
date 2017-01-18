class TokensController < ApplicationController
  def create
    @group = Group.find_by(code: params[:group_code])

    if current_user && current_user.id == @group.user_id
      @rule = Rule.find(params[:rule_id])
      @token = @rule.tokens.create(token_params)

      respond_to do |format|
        case params[:token][:type]
        when 'source'
          format.js { render file: 'tokens/source_create.js.erb' }
        when 'whitelist'
          format.js { render file: 'tokens/whitelist_create.js.erb' }
        when 'blacklist'
          format.js { render file: 'tokens/blacklist_create.js.erb' }
        end
      end
    end
  end

  def update
    @group = Group.find_by(code: params[:group_code])

    if current_user && current_user.id == @group.user_id
      @rule = Rule.find(params[:rule_id])
      @token = @rule.tokens.find(params[:id])
      @token.update(token_params) if @token
    end
  end

  def destroy
    @group = Group.find_by(code: params[:group_code])

    if current_user && current_user.id == @group.user_id
      @rule = Rule.find(params[:rule_id])
      @token = @rule.tokens.find(params[:id])

      @token.destroy if @token
    end
  end

  private

    def token_params
      params.require(:token).permit(:token, :names, :groups, :case, :regex, :invert, :type)
    end
end
