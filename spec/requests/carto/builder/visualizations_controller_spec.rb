require_relative '../../../spec_helper'
require_relative '../../../factories/users_helper'

describe Carto::Builder::VisualizationsController do
  include Warden::Test::Helpers

  include_context 'users helper'

  describe '#show' do
    before(:each) do
      map = FactoryGirl.create(:map, user_id: @user1.id)
      @visualization = FactoryGirl.create(:carto_visualization, user_id: @user1.id, map_id: map.id)
      @user1.stubs(:has_feature_flag?).with('editor-3').returns(true)
      @user1.stubs(:has_feature_flag?).with('new_geocoder_quota').returns(true)

      login(@user1)
    end

    it 'returns 404 for non-editor users requests' do
      @user1.stubs(:has_feature_flag?).with('editor-3').returns(false)

      get builder_visualization_url(id: @visualization.id)

      response.status.should == 404
    end

    it 'redirects to editor if disabled' do
      @user1.stubs(:builder_enabled).returns(false)

      get builder_visualization_url(id: @visualization.id)

      response.status.should eq 302
      response.location.should include '/viz/' + @visualization.id
    end

    it 'returns 404 for non-existent visualizations' do
      get builder_visualization_url(id: UUIDTools::UUID.timestamp_create.to_s)

      response.status.should == 404
    end

    it 'returns 404 for non-derived visualizations' do
      @visualization.type = Carto::Visualization::TYPE_CANONICAL
      @visualization.save
      get builder_visualization_url(id: UUIDTools::UUID.timestamp_create.to_s)

      response.status.should == 404
    end

    it 'returns 403 for visualizations not writable by user' do
      @other_visualization = FactoryGirl.create(:carto_visualization)

      get builder_visualization_url(id: @other_visualization.id)

      response.status.should == 403
    end

    describe 'viewer users' do
      after(:each) do
        if @user1.viewer
          @user1.viewer = false
          @user1.save
        end
      end

      it 'get 403 for their visualizations at the builder' do
        @user1.viewer = true
        @user1.save

        get builder_visualization_url(id: @visualization.id)

        response.status.should eq 403
      end
    end

    it 'returns visualization' do
      get builder_visualization_url(id: @visualization.id)

      response.status.should == 200
      response.body.should include(@visualization.id)
    end

    it 'does not show raster kind visualizations' do
      @visualization.kind = Carto::Visualization::KIND_RASTER
      @visualization.save

      get builder_visualization_url(id: @visualization.id)

      response.status.should == 404
    end

    it 'does not show slide type visualizations' do
      @visualization.type = Carto::Visualization::TYPE_SLIDE
      @visualization.save

      get builder_visualization_url(id: @visualization.id)

      response.status.should == 404
    end

    it 'defaults to generate vizjson with vector=false' do
      get builder_visualization_url(id: @visualization.id)

      response.status.should == 200
      response.body.should include('\"vector\":false')
    end

    it 'generates vizjson with vector=true with flag' do
      get builder_visualization_url(id: @visualization.id, vector: true)

      response.status.should == 200
      response.body.should include('\"vector\":true')
    end

    it 'displays analysesData' do
      analysis = FactoryGirl.create(:source_analysis, visualization_id: @visualization.id, user_id: @user1.id)

      get builder_visualization_url(id: @visualization.id, vector: true)

      response.status.should == 200
      response.body.should include(analysis.natural_id)
    end
  end
end
