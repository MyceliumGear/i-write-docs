FactoryGirl.define do
  factory :address_provider do
    user

    factory :cashila_address_provider, class: 'AddressProviders::Cashila' do
      secret 'MA=='
      token 'uuid'
    end
  end

  factory :cashila_user_details, class: HashWithIndifferentAccess do
    initialize_with {
      {
        first_name:   'Example',
        last_name:    'Xample',
        address:      'somewhere',
        postal_code:  '000000',
        city:         'Vilnius',
        country_code: 'LT',
      }
    }
  end

  factory :cashila_recipient_details, class: HashWithIndifferentAccess do
    initialize_with {
      {
        recipient_name:         'Example Xample',
        recipient_address:      'somewhere',
        recipient_postal_code:  '000000',
        recipient_city:         'Vilnius',
        recipient_country_code: 'LT',
        recipient_bic:          'BPHKPLPK',
        recipient_iban:         'LT121000011101001000',
      }
    }
  end

  factory :cashila_files, class: HashWithIndifferentAccess do
    initialize_with {
      file = [File.expand_path('../../fixtures/multipass.jpg', __FILE__), nil, true]
      {
        'gov-id-front': Rack::Test::UploadedFile.new(*file),
        'gov-id-back':  Rack::Test::UploadedFile.new(*file),
        residence:      Rack::Test::UploadedFile.new(*file),
      }
    }
  end
end
