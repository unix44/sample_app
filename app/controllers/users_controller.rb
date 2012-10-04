class UsersController < ApplicationController

    before_filter :authorize, :only => [ :new, :create ]
    before_filter :authenticate, :only => [ :edit, :update, :index, :destroy ]
    before_filter :correct_user, :only => [ :edit, :update ]
    before_filter :admin_user, :only => :destroy
    
    def index
        @users = User.paginate( :page => params[:page] )
        @title = "All users"
    end

    def new

        @user = User.new
        @title = "Sign up"
    end

    def show

        @user = User.find( params[:id] )
        @microposts = @user.microposts.paginate( :page => params[:page] )
        @title = @user.name
    end

    def create

        @user = User.new( params[:user] )

        if @user.save

            sign_in( @user )
            flash[:success] = "Welcome to the Sample App!"
            redirect_to @user
        else

            @user.password = nil
            @user.password_confirmation = nil
            @title = "Sign up"
            render "new"
        end
    end

    def edit

        #@user = User.find( params[:id] )
        @title = "Edit user"
    end

    def update

        #@user = User.find( params[:id] )

        if @user.update_attributes( params[:user] )
            flash[:success] = "Profile updated"
            redirect_to @user
        else
            @title = "Edit user"
            render "edit"
        end
    end

    def destroy
        user = User.find(params[:id])

        unless current_user == user
            User.find(params[:id]).destroy
            flash[:success] = "User destroyed."
        end

        redirect_to( users_path )
    end

    private

        def correct_user
            @user = User.find( params[:id] )
            redirect_to( root_path ) unless current_user?( @user )
        end

        def admin_user
            redirect_to( root_path ) unless current_user.admin?
        end

        def authorize
            redirect_to( root_path ) if signed_in?
        end

end
