require 'geocoder'

module Pyr::Geo::Util
  class Coder

      attr_accessor :latitude, :longitude, :country, :state, :city, :postal_code, :address

      RAD_2_DEG =  (180.0/Math::PI)
      DEG_2_RAD = (Math::PI/180.0)
      EARTH_RADIUS = 6371.0

      COUNTRY_NAMES_TO_ISO = {
        "AFGHANISTAN"=>"AF",
        "ALAND ISLANDS"=>"AX",
        "ALBANIA"=>"AL",
        "ALGERIA"=>"DZ",
        "AMERICAN SAMOA"=>"AS",
        "ANDORRA"=>"AD",
        "ANGOLA"=>"AO",
        "ANGUILLA"=>"AI",
        "ANTARCTICA"=>"AQ",
        "ANTIGUA AND BARBUDA"=>"AG",
        "ARGENTINA"=>"AR",
        "ARMENIA"=>"AM",
        "ARUBA"=>"AW",
        "AUSTRALIA"=>"AU",
        "AUSTRIA"=>"AT",
        "AZERBAIJAN"=>"AZ",
        "BAHAMAS"=>"BS",
        "BAHRAIN"=>"BH",
        "BANGLADESH"=>"BD",
        "BARBADOS"=>"BB",
        "BELARUS"=>"BY",
        "BELGIUM"=>"BE",
        "BELIZE"=>"BZ",
        "BENIN"=>"BJ",
        "BERMUDA"=>"BM",
        "BHUTAN"=>"BT",
        "BOLIVIA"=>"BO",
        "BOSNIA AND HERZEGOVINA"=>"BA",
        "BOTSWANA"=>"BW",
        "BOUVET ISLAND"=>"BV",
        "BRAZIL"=>"BR",
        "BRITISH INDIAN OCEAN TERRITORY"=>"IO",
        "BRUNEI DARUSSALAM"=>"BN",
        "BULGARIA"=>"BG",
        "BURKINA FASO"=>"BF",
        "BURUNDI"=>"BI",
        "CAMBODIA"=>"KH",
        "CAMEROON"=>"CM",
        "CANADA"=>"CA",
        "CAPE VERDE"=>"CV",
        "CAYMAN ISLANDS"=>"KY",
        "CENTRAL AFRICAN REPUBLIC"=>"CF",
        "CHAD"=>"TD",
        "CHILE"=>"CL",
        "CHINA"=>"CN",
        "CHRISTMAS ISLAND"=>"CX",
        "COCOS (KEELING) ISLANDS"=>"CC",
        "COLOMBIA"=>"CO",
        "COMOROS"=>"KM",
        "CONGO"=>"CG",
        "CONGO, THE DEMOCRATIC REPUBLIC OF THE"=>"CD",
        "COOK ISLANDS"=>"CK",
        "COSTA RICA"=>"CR",
        "COTE D'IVOIRE"=>"CI",
        "CROATIA"=>"HR",
        "CUBA"=>"CU",
        "CYPRUS"=>"CY",
        "CZECH REPUBLIC"=>"CZ",
        "DENMARK"=>"DK",
        "DJIBOUTI"=>"DJ",
        "DOMINICA"=>"DM",
        "DOMINICAN REPUBLIC"=>"DO",
        "ECUADOR"=>"EC",
        "EGYPT"=>"EG",
        "EL SALVADOR"=>"SV",
        "EQUATORIAL GUINEA"=>"GQ",
        "ERITREA"=>"ER",
        "ESTONIA"=>"EE",
        "ETHIOPIA"=>"ET",
        "FALKLAND ISLANDS (MALVINAS)"=>"FK",
        "FAROE ISLANDS"=>"FO",
        "FIJI"=>"FJ",
        "FINLAND"=>"FI",
        "FRANCE"=>"FR",
        "FRENCH GUIANA"=>"GF",
        "FRENCH POLYNESIA"=>"PF",
        "FRENCH SOUTHERN TERRITORIES"=>"TF",
        "GABON"=>"GA",
        "GAMBIA"=>"GM",
        "GEORGIA"=>"GE",
        "GERMANY"=>"DE",
        "GHANA"=>"GH",
        "GIBRALTAR"=>"GI",
        "GREECE"=>"GR",
        "GREENLAND"=>"GL",
        "GRENADA"=>"GD",
        "GUADELOUPE"=>"GP",
        "GUAM"=>"GU",
        "GUATEMALA"=>"GT",
        "GUINEA"=>"GN",
        "GUINEA-BISSAU"=>"GW",
        "GUYANA"=>"GY",
        "HAITI"=>"HT",
        "HEARD ISLAND AND MCDONALD ISLANDS"=>"HM",
        "HOLY SEE (VATICAN CITY STATE)"=>"VA",
        "HONDURAS"=>"HN",
        "HONG KONG"=>"HK",
        "HUNGARY"=>"HU",
        "ICELAND"=>"IS",
        "INDIA"=>"IN",
        "INDONESIA"=>"ID",
        "IRAN, ISLAMIC REPUBLIC OF"=>"IR",
        "IRAN"=>"IR",
        "IRAQ"=>"IQ",
        "IRELAND"=>"IE",
        "ISRAEL"=>"IL",
        "ITALY"=>"IT",
        "JAMAICA"=>"JM",
        "JAPAN"=>"JP",
        "JORDAN"=>"JO",
        "KAZAKHSTAN"=>"KZ",
        "KENYA"=>"KE",
        "KIRIBATI"=>"KI",
        "KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF"=>"KP",
        "KOREA, REPUBLIC OF"=>"KR",
        "KOREA"=>"KR",
        "KUWAIT"=>"KW",
        "KYRGYZSTAN"=>"KG",
        "LAO PEOPLE'S DEMOCRATIC REPUBLIC"=>"LA",
        "LATVIA"=>"LV",
        "LEBANON"=>"LB",
        "LESOTHO"=>"LS",
        "LIBERIA"=>"LR",
        "LIBYAN ARAB JAMAHIRIYA"=>"LY",
        "LIECHTENSTEIN"=>"LI",
        "LITHUANIA"=>"LT",
        "LUXEMBOURG"=>"LU",
        "MACAO"=>"MO",
        "MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF"=>"MK",
        "MACEDONIA"=>"MK",
        "MADAGASCAR"=>"MG",
        "MALAWI"=>"MW",
        "MALAYSIA"=>"MY",
        "MALDIVES"=>"MV",
        "MALI"=>"ML",
        "MALTA"=>"MT",
        "MARSHALL ISLANDS"=>"MH",
        "MARTINIQUE"=>"MQ",
        "MAURITANIA"=>"MR",
        "MAURITIUS"=>"MU",
        "MAYOTTE"=>"YT",
        "MEXICO"=>"MX",
        "MICRONESIA, FEDERATED STATES OF"=>"FM",
        "MICRONESIA"=>"FM",
        "MOLDOVA, REPUBLIC OF"=>"MD",
        "MOLDOVA"=>"MD",
        "MONACO"=>"MC",
        "MONGOLIA"=>"MN",
        "MONTSERRAT"=>"MS",
        "MOROCCO"=>"MA",
        "MOZAMBIQUE"=>"MZ",
        "MYANMAR"=>"MM",
        "NAMIBIA"=>"NA",
        "NAURU"=>"NR",
        "NEPAL"=>"NP",
        "NETHERLANDS"=>"NL",
        "NETHERLANDS ANTILLES"=>"AN",
        "NEW CALEDONIA"=>"NC",
        "NEW ZEALAND"=>"NZ",
        "NICARAGUA"=>"NI",
        "NIGER"=>"NE",
        "NIGERIA"=>"NG",
        "NIUE"=>"NU",
        "NORFOLK ISLAND"=>"NF",
        "NORTHERN MARIANA ISLANDS"=>"MP",
        "NORWAY"=>"NO",
        "OMAN"=>"OM",
        "PAKISTAN"=>"PK",
        "PALAU"=>"PW",
        "PALESTINIAN TERRITORY, OCCUPIED"=>"PS",
        "PALESTINE"=>"PS",
        "PANAMA"=>"PA",
        "PAPUA NEW GUINEA"=>"PG",
        "PARAGUAY"=>"PY",
        "PERU"=>"PE",
        "PHILIPPINES"=>"PH",
        "PITCAIRN"=>"PN",
        "POLAND"=>"PL",
        "PORTUGAL"=>"PT",
        "PUERTO RICO"=>"PR",
        "QATAR"=>"QA",
        "REUNION"=>"RE",
        "ROMANIA"=>"RO",
        "RUSSIAN FEDERATION"=>"RU",
        "RWANDA"=>"RW",
        "SAINT HELENA"=>"SH",
        "SAINT KITTS AND NEVIS"=>"KN",
        "SAINT LUCIA"=>"LC",
        "SAINT PIERRE AND MIQUELON"=>"PM",
        "SAINT VINCENT AND THE GRENADINES"=>"VC",
        "SAMOA"=>"WS",
        "SAN MARINO"=>"SM",
        "SAO TOME AND PRINCIPE"=>"ST",
        "SAUDI ARABIA"=>"SA",
        "SENEGAL"=>"SN",
        "SERBIA AND MONTENEGRO"=>"CS",
        "SEYCHELLES"=>"SC",
        "SIERRA LEONE"=>"SL",
        "SINGAPORE"=>"SG",
        "SLOVAKIA"=>"SK",
        "SLOVENIA"=>"SI",
        "SOLOMON ISLANDS"=>"SB",
        "SOMALIA"=>"SO",
        "SOUTH AFRICA"=>"ZA",
        "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS"=>"GS",
        "SPAIN"=>"ES",
        "SRI LANKA"=>"LK",
        "SUDAN"=>"SD",
        "SURINAME"=>"SR",
        "SVALBARD AND JAN MAYEN"=>"SJ",
        "SWAZILAND"=>"SZ",
        "SWEDEN"=>"SE",
        "SWITZERLAND"=>"CH",
        "SYRIAN ARAB REPUBLIC"=>"SY",
        "TAIWAN, PROVINCE OF CHINA"=>"TW",
        "TAJIKISTAN"=>"TJ",
        "TANZANIA, UNITED REPUBLIC OF"=>"TZ",
        "TANZANIA"=>"TZ",
        "THAILAND"=>"TH",
        "TIMOR-LESTE"=>"TL",
        "TOGO"=>"TG",
        "TOKELAU"=>"TK",
        "TONGA"=>"TO",
        "TRINIDAD AND TOBAGO"=>"TT",
        "TUNISIA"=>"TN",
        "TURKEY"=>"TR",
        "TURKMENISTAN"=>"TM",
        "TURKS AND CAICOS ISLANDS"=>"TC",
        "TUVALU"=>"TV",
        "UGANDA"=>"UG",
        "UKRAINE"=>"UA",
        "UNITED ARAB EMIRATES"=>"AE",
        "UAE"=>"AE",
        "UNITED KINGDOM"=>"GB",
        "GREAT BRITAIN" => "GB",
        "UNITED STATES"=>"US",
        "USA" => "US",
        "UNITED STATES OF AMERICA" => "US",
        "UNITED STATES MINOR OUTLYING ISLANDS"=>"UM",
        "URUGUAY"=>"UY",
        "UZBEKISTAN"=>"UZ",
        "VANUATU"=>"VU",
        "VENEZUELA"=>"VE",
        "VIET NAM"=>"VN",
        "VIRGIN ISLANDS, BRITISH"=>"VG",
        "BRITISH VIRGIN ISLANDS"=>"VG",
        "VIRGIN ISLANDS, U.S."=>"VI",
        "WALLIS AND FUTUNA"=>"WF",
        "WESTERN SAHARA"=>"EH",
        "YEMEN"=>"YE",
        "ZAMBIA"=>"ZM",
        "ZIMBABWE"=>"ZW" }
    
      CAN_STATE_NAMES_TO_SHORT = {
        "Ontario" => "ON",
        "Quebec" => "QC",
        "Nova Scotia" => "NS",
        "New Brunswick" => "NB",
        "Manitoba" => "MB",
        "British Columbia" => "BC",
        "Prince Edward Island" => "PE",
        "Saskatchewan" => "SK",
        "Alberta" => "AB",
        "Newfoundland" => "NL",
        "Labrador" => "NL",
        "Newfoundland and Labrador" => "NL",
        "Northwest Territories" => "NT",
      }.each_with_object({}) do |(k,v), h| h[k.upcase] = v end
    
      US_STATE_NAMES_TO_SHORT = {
        "Alabama"  => "AL",
        "Alaska"=> 	  "AK",
        "Arizona"=> 	  "AZ",
        "Arkansas"=> 	  "AR",
        "California"=> 	  "CA",
        "Colorado"	=>   "CO",
        "Connecticut"	=>   "CT",
        "Delaware"=> 	  "DE",
        "Florida"=> 	  "FL",
        "Georgia"=> 	  "GA",
        "Hawaii"=> 	  "HI",
        "Idaho"=> 	  "ID",
        "Illinois"=> 	  "IL",
        "Indiana"=> 	  "IN",
        "Iowa"=> 	  "IA",
        "Kansas"=> 	  "KS",
        "Kentucky"=> 	  "KY",
        "Louisiana"=> 	  "LA",
        "Maine"=> 	  "ME",
        "Maryland"=> 	  "MD",
        "Massachusetts"=>  "MA",
        "Michigan"	=>   "MI",
        "Minnesota"	 =>  "MN",
        "Mississippi"	 =>  "MS",
        "Missouri"	=>   "MO",
        "Montana"	=>   "MT",
        "Nebraska"	=>   "NE",
        "Nevada"	=>   "NV",
        "New Hampshire"=>  "NH",
        "New Jersey"	=>   "NJ",
        "New Mexico"	=>   "NM",
        "New York"	=>   "NY",
        "North Carolina"=>  "NC",
        "North Dakota"=>   "ND",
        "Ohio"	=>   "OH",
        "Oklahoma"	=>   "OK",
        "Oregon"	 =>  "OR",
        "Pennsylvania"=>   "PA",
        "Rhode Island" =>  "RI",
        "South Carolina"=>  "SC",
        "South Dakota" =>  "SD",
        "Tennessee"=> 	  "TN",
        "Texas"=> 	  "TX",
        "Utah"=> 	  "UT",
        "Vermont"	=>   "VT",
        "Virginia"	=>   "VA",
        "Washington"	=>   "WA",
        "West Virginia"=>  "WV",
        "Wisconsin"	=>   "WI",
        "Wyoming"	=>   "WY",
        "District of Columbia" => "DC"
      }.each_with_object({}) do |(k,v), h| h[k.upcase] = v end

    def initialize(args={})
      args.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    
      if self.country
        if self.country.length > 2
          self.country = COUNTRY_NAMES_TO_ISO[self.country.upcase]
        else
          self.country = self.country.upcase
        end
      end
    
      if ["US", "CA"].include? self.country
        if self.state and self.state.length > 2
          self.state = US_STATE_NAMES_TO_SHORT[self.state.upcase] if self.country == "US"
          self.state = CAN_STATE_NAMES_TO_SHORT[self.state.upcase] if self.country == "CA"
        else
          self.state = self.state.upcase
        end
      end
    
    end
    
    def as_dict
      { :latitude => self.latitude,
        :longitude => self.longitude,
        :country => self.country,
        :state => self.state,
        :city => self.city,
        :postal_code => self.postal_code,
          :address => self.address 
      }
    end
    
    def to_s
      as_dict.to_s
    end

    def self.reverse_geocode(*args)
      if args.length > 1
        s = args.map{ |m| "#{m}" }.join(",")
      else
        s = "#{args[0]}"
      end
  
      Rails.logger.debug "GEOCODE SEARCH => [ #{s} ] "
      result = Geocoder.search(s)
      return nil if result.nil?
    
    
      result = result[0]
      Rails.logger.debug "GEO: #{result.inspect}"
    
      return nil if result.nil?
    
      self.new( :latitude => result.latitude,
               :longitude => result.longitude,
               :country => result.country_code, 
               :state => result.state_code, 
               :city => result.city, 
               :address => result.address, 
               :postal_code => result.postal_code 
             )
    end
    
    def self.reverse_geocode_from_lat_long(lat, long)
      self.reverse_geocode("#{lat}, #{long}")
    end

    def self.to_cartesian_coords(latitude, longitude) 
      lat_rad = DEG_2_RAD * latitude
      lng_rad = DEG_2_RAD * longitude
  
      x = EARTH_RADIUS * Math.cos(lat_rad) * Math.cos(lng_rad);
      y = EARTH_RADIUS * Math.cos(lat_rad) * Math.sin(lng_rad);
      z = EARTH_RADIUS * Math.sin(lat_rad); 
  
      return [x, y, z]
    end
  
    def self.to_lat_lng(x, y, z)
      r = Math.sqrt(x*x + y*y + z*z)
      lat = RAD_2_DEG * Math.asin(z / r)
      lng = RAD_2_DEG * Math.atan2(y, x)
      return [lat, lng]
    end
  
    def self.cluster(lats_and_lngs)
      #puts "CLUSTERING #{lats_and_lngs}"
      x, y, z = 0, 0, 0
  
      lats_and_lngs.each do |item|
        lat, lng = item
        #puts "LAT => #{lat}, LNG => #{lng}"
        val = to_cartesian_coords(lat, lng)
        x = x + val[0]
        y = y + val[1]
        z = z + val[2]
      end

      count = lats_and_lngs.count
      x = x / count
      y = y / count
      z = z / count

      return to_lat_lng(x, y, z)
    end
      
  end
end
