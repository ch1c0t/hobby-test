class Hobby::Test::Exchange
  class Response < OpenStruct
    def == excon_response
      status == excon_response.status &&
        body == excon_response.body
    end
  end
end
