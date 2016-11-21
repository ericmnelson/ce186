# app/controllers/users_controller.rb

class UsersController < ApplicationController
  skip_before_filter :set_current_user, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user=User.find(params[:id])
    @scores = User.scores.sort_by {|k,v| -v}
    @score = 0
    @rank = 0
    @scores.each_with_index do |elem, i|
      if elem[0] == @user.id
        @score = elem[1]
        @rank = i + 1
      end
    end
  end

  # GET /users/new
  def new
    render :layout => "empty"
  end

  # GET /dashboard
  def dashboard
    @users = User.where(:house => current_house)
    puts User.scores
    @scores = User.scores.sort_by {|k,v| -v}

    @last_week_scores = User.scores(1).sort_by {|k,v| -v}
    @diff_scores = @scores.to_h.dup
    @last_week_scores.to_h.each do |u_id, score|
      @diff_scores[u_id] -= score
    end

    @rank_diff = {}
    @last_week_scores.each_with_index do |elem, i|
      @rank_diff[elem[0]] = i
    end
    @scores.each_with_index do |elem, i|
      @rank_diff[elem[0]] -= i
    end
  end

  # GET /users/1/edit
  def edit
    puts params
  end

  def shower_data
    u = User.find(params[:id])
    num_days = params[:num_days].to_i
    render :json => u.shower_data(num_days)
  end

  def percent_consumption
    u = User.find(params[:id])
    percent = u.precent_total_consumption
    puts "^" *76
    puts percent
    render :json => percent.round(1)
  end

  # POST /users
  # POST /users.json
  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      puts @params
      params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :password, :password_confirmation, :avatar)
    end
end
