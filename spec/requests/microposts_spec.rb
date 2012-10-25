require 'spec_helper'

describe "Microposts" do

    before( :each ) do
        @user = Factory( :user )
        visit signin_path
        fill_in :email,     :with => @user.email
        fill_in :password,  :with => @user.password
        click_button
    end

    describe "creation" do

        describe "failure" do
            
            it "should not make a new micropost" do
                lambda do
                    visit root_path
                    fill_in :micropost_content, :with => ""
                    click_button
                    response.should render_template( 'pages/home' )
                    response.should have_selector( 'div#error_explanation' )
                end.should_not change( Micropost, :count )
            end

        end

        describe "success" do

            it "should make a new micropost" do
                content = "Lorem ipsum blah blah blah"
                lambda do
                    visit root_path
                    fill_in :micropost_content, :with => content
                    click_button
                    response.should have_selector( 'span.content', :content => content )
                end.should change( Micropost, :count ).by( 1 )
            end

        end

    end

    describe "count" do

        it "should one micropost" do
            mp1 = Factory( :micropost, :user => @user )
            visit root_path
            response.should have_selector( 'span.microposts', :content => '1 micropost' )
        end

        it "should be a lot of microposts" do
            microposts = Array.new
            20.times do
                microposts.push( Factory( :micropost, :user => @user ) )
            end
            visit root_path
            response.should have_selector( 'span.microposts', :content => '20 microposts' )
        end

        it "should paginate microposts" do
            microposts = Array.new
            50.times do
                microposts.push Factory( :micropost, :user => @user )
            end
            visit( root_path )
            response.should have_selector( 'div.pagination' )
            response.should have_selector( 'span.disabled', :content => "Previous" )
            response.should have_selector( 'a', :href    => "/?page=2", 
                                                :content => '2' )
            response.should have_selector( 'a', :href    => "/?page=2",
                                                :content => "Next" )
        end
    end

end
