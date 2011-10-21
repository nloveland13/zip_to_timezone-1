require 'algorithms'
require 'zip_to_timezone/version'

class ZipToTimezone
  MAPPINGS = {
    "Hawaii" => ['967', '968'],
    "Alaska" => ['995'..'999'],
    "Pacific Time (US & Canada)" => ['838', '889'..'891', '893'..'898', '90'..'95', '960', '961', '970'..'978', '980'..'986', '988'..'994'],
    "Mountain Time (US & Canada)" => [
      '59', # => MT
      '80', '810'..'816', # => CO
      '82', '830', '831', # => WY
      '832'..'837', # => ID
      '840'..'847', # => UT
      '870'..'875', # => NM
      '882', # => Roswell, NM
      '885', '799', # => El Paso, TX
      '979', # => East OR
      '865', # => North East AZ
      '586', # => West ND
      '577', # => West SD
      '693', # => West NE
      '67733', '67735', '678', # => West KS
    ],
    "Arizona" => ['850'..'853', '855'..'857', '859', '860', '863', '864'],
    "Central Time (US & Canada)" => [
      '733', '750'..'770', '772'..'779', '78', '790'..'798', # => TX
      '730', '731', '734'..'741', '743'..'749', # => OK
      '700', '701', '703'..'708', '710'..'714', # => LA
      '386'..'397', # => MS
      '350'..'352', '354'..'359', '36', # => AL
      '370'..'372', '375', '380'..'385', # => West TN
      '420'..'424', '427', # => West KY
      '716'..'719', '72', # => AR
      '630', '631', '633'..'641', '644'..'658', # => MO
      '660'..'662', '664'..'677', '67862', '679'..'681', # => East KS
      '680', '681', '683'..'692', # => East NE
      '570'..'576', # => East SD
      '50', '510'..'516', '520'..'528', # => IA
      '60', '61', '620', '622'..'629', # => IL
      '530'..'532', '534', '535', '537'..'539', '54', # => WI
      '550', '551', '553'..'567', # => MN
      '580'..'585', '587', '588', # => East ND
      '463', '464', '476', '477', # => West IN
      '49920', '49927', '49911', '49915', '49935', '49938', # => West MI
      '324', '325'# => West FL
    ],
    "Eastern Time (US & Canada)" => [
      '569', '200', '202'..'205', # => DC
      '039', '04', # => ME
      '050'..'054', '056'..'059', # => VT
      '030'..'038', # => NH
      '01', '020'..'027', '055', # => MA
      '028', '029', # => RI
      '06', # => CT
      '005', '10'..'14', # => NY
      '07', '08', # => NJ
      '150'..'196', # => PA
      '206'..'209', '21', # => MD
      '197'..'199', # => DE
      '201', '220'..'246', # => VA
      '247'..'249', '25', '260'..'268', # => WV
      '43'..'45', # => OH
      '48', '49', # => East MI
      '460'..'462', '465'..'475', '478', '479', # => East IN
      '40', '410'..'418', '425', '426', # => East KY
      '373', '374', '376'..'379', # => East TN
      '27', '28', # => NC
      '29', # => SC
      '30', '31', '398', '399', # => GA
      '320'..'323', '326'..'329', '33', '341', '342', '344', '346', '347', '349' # => East FL
    ]
  }

  def self.mapper
    @mapper ||= self.build_mapper
  end

  def self.get_timezone_for(zip)
    self.mapper[self.mapper.longest_prefix(zip)]
  end

  def self.build_mapper
    mapper = Containers::Trie.new
    MAPPINGS.each do |tz, value|
      value.map{|v| v.is_a?(Range) ? Array(v) : v}.flatten.each do |zip_prefix|
        mapper.push(zip_prefix, tz)
      end
    end
    return mapper
  end
end
