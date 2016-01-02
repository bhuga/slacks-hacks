class UpdatesController < ApplicationController
  def squirrel
    version = params[:version]
    if version == latest_version
      return head :no_content
    end
    return render :json => latest_json
  end

  private

  def latest_json
    {
      "url" => "https://dinosaur.s3.amazonaws.com/hackable-slack-client-#{latest_version}.zip",
      "notes" => "Latest version",
      "name" => latest_version,
      "pub_date" => Time.now.iso8601
    }
  end

  def latest_version
    ENV["LATEST_CLIENT_VERSION"]
  end
end
