module NikeV2
  class Activity < Resource
    extend Forwardable
    def_delegator :@person, :access_token

    API_URL = '/me/sport/activities'

    def initialize(attributes = {})
      raise "#{self.class} requires s person." unless attributes.keys.include?(:person)
      raise "#{self.class} requires an activityId." unless attributes.keys.include?('activityId')
      super(attributes)
    end

    def gps_data
      @gps_data ||= NikeV2::GpsData.new(:activity => self)
    end

    def metrics
      @metrics
    end

    def load_data
      data = fetch_data
      @metrics = NikeV2::Metrics.new(self, data.delete('metrics'))

      set_attributes(data)
      true
    end

    def started_at
      @started_at ||= Time.parse(self.start_time)
    end

    private 
    def api_url
      API_URL + "/#{self.activity_id}"
    end
  end
end