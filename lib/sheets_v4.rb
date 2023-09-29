# frozen_string_literal: true

require_relative 'sheets_v4/version'
require_relative 'sheets_v4/color'
require_relative 'sheets_v4/validate_api_object'

require 'json'
require 'logger'
require 'net/http'

# Unofficial helpers for the Google Sheets V4 API
#
# @api public
#
module SheetsV4
  # Validate the object using the named JSON schema
  #
  # The JSON schemas are loaded from the Google Disocvery API. The schemas names are
  # returned by `SheetsV4.api_object_schemas.keys`.
  #
  # @example
  #   schema_name = 'BatchUpdateSpreadsheetRequest'
  #   object = { 'requests' => [] }
  #   SheetsV4.validate_api_object(schema_name:, object:)
  #
  # @param schema_name [String] the name of the schema to validate against
  # @param object [Object] the object to validate
  # @param logger [Logger] the logger to use for logging error, info, and debug message
  #
  # @raise [RuntimeError] if the object does not conform to the schema
  #
  # @return [void]
  #
  def self.validate_api_object(schema_name:, object:, logger: Logger.new(nil))
    ValidateApiObject.new(logger).call(schema_name, object)
  end

  # A hash of schemas keyed by the schema name loaded from the Google Discovery API
  #
  # @example
  #   SheetsV4.api_object_schemas #=> { 'PersonSchema' => { 'type' => 'object', ... } ... }
  #
  # @return [Hash<String, Object>] a hash of schemas keyed by schema name
  #
  def self.api_object_schemas
    schema_load_semaphore.synchronize { @api_object_schemas ||= load_api_object_schemas }
  end

  # Validate
  # A mutex used to synchronize access to the schemas so they are only loaded
  # once.
  #
  @schema_load_semaphore = Thread::Mutex.new

  # A mutex used to synchronize access to the schemas so they are only loaded once
  #
  # @return [Thread::Mutex]
  #
  # @api private
  #
  def self.schema_load_semaphore = @schema_load_semaphore

  # Load the schemas from the Google Discovery API
  #
  # @return [Hash<String, Object>] a hash of schemas keyed by schema name
  #
  # @api private
  #
  def self.load_api_object_schemas
    source = 'https://sheets.googleapis.com/$discovery/rest?version=v4'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    JSON.parse(data)['schemas'].tap do |schemas|
      schemas.each { |_name, schema| schema['unevaluatedProperties'] = false }
    end
  end

  # Return a color object for the given name from SheetsV4::COLORS
  #
  # @example
  #   SheetsV4::Color.color(:red) #=> { "red": 1.0, "green": 0.0, "blue": 0.0 }
  #
  # @param name [Symbol] the name of the color
  # @return [Hash] the color object
  # @api public
  def self.color(name)
    SheetsV4::COLORS[name.to_sym]
  end

  # Colors to use in the Google Sheets API
  COLORS = {
    # Standard Google Sheets colors

    black: { red: 0.000000000, green: 0.000000000, blue: 0.000000000 },
    dark_gray4: { red: 0.262745098, green: 0.262745098, blue: 0.262745098 },
    dark_gray3: { red: 0.400000000, green: 0.400000000, blue: 0.400000000 },
    dark_gray2: { red: 0.600000000, green: 0.600000000, blue: 0.600000000 },
    dark_gray1: { red: 0.717647059, green: 0.717647059, blue: 0.717647059 },
    gray: { red: 0.800000000, green: 0.800000000, blue: 0.800000000 },
    light_gray1: { red: 0.850980392, green: 0.850980392, blue: 0.850980392 },
    light_gray2: { red: 0.937254902, green: 0.937254902, blue: 0.937254902 },
    light_gray3: { red: 0.952941176, green: 0.952941176, blue: 0.952941176 },
    white: { red: 1.000000000, green: 1.000000000, blue: 1.000000000 },
    red_berry: { red: 0.596078431, green: 0.000000000, blue: 0.000000000 },
    red: { red: 1.000000000, green: 0.000000000, blue: 0.000000000 },
    orange: { red: 1.000000000, green: 0.600000000, blue: 0.000000000 },
    yellow: { red: 1.000000000, green: 1.000000000, blue: 0.000000000 },
    green: { red: 0.000000000, green: 1.000000000, blue: 0.000000000 },
    cyan: { red: 0.000000000, green: 1.000000000, blue: 1.000000000 },
    cornflower_blue: { red: 0.290196078, green: 0.525490196, blue: 0.909803922 },
    blue: { red: 0.000000000, green: 0.000000000, blue: 1.000000000 },
    purple: { red: 0.600000000, green: 0.000000000, blue: 1.000000000 },
    magenta: { red: 1.000000000, green: 0.000000000, blue: 1.000000000 },
    light_red_berry3: { red: 0.901960784, green: 0.721568627, blue: 0.686274510 },
    light_red3: { red: 0.956862745, green: 0.800000000, blue: 0.800000000 },
    light_orange3: { red: 0.988235294, green: 0.898039216, blue: 0.803921569 },
    light_yellow3: { red: 1.000000000, green: 0.949019608, blue: 0.800000000 },
    light_green3: { red: 0.850980392, green: 0.917647059, blue: 0.827450980 },
    light_cyan3: { red: 0.815686275, green: 0.878431373, blue: 0.890196078 },
    light_cornflower_blue3: { red: 0.788235294, green: 0.854901961, blue: 0.972549020 },
    light_blue3: { red: 0.811764706, green: 0.886274510, blue: 0.952941176 },
    light_purple3: { red: 0.850980392, green: 0.823529412, blue: 0.913725490 },
    light_magenta3: { red: 0.917647059, green: 0.819607843, blue: 0.862745098 },
    light_red_berry2: { red: 0.866666667, green: 0.494117647, blue: 0.419607843 },
    light_red2: { red: 0.917647059, green: 0.600000000, blue: 0.600000000 },
    light_orange2: { red: 0.976470588, green: 0.796078431, blue: 0.611764706 },
    light_yellow2: { red: 1.000000000, green: 0.898039216, blue: 0.600000000 },
    light_green2: { red: 0.713725490, green: 0.843137255, blue: 0.658823529 },
    light_cyan2: { red: 0.635294118, green: 0.768627451, blue: 0.788235294 },
    light_cornflower_blue2: { red: 0.643137255, green: 0.760784314, blue: 0.956862745 },
    light_blue2: { red: 0.623529412, green: 0.772549020, blue: 0.909803922 },
    light_purple2: { red: 0.705882353, green: 0.654901961, blue: 0.839215686 },
    light_magenta2: { red: 0.835294118, green: 0.650980392, blue: 0.741176471 },
    light_red_berry1: { red: 0.800000000, green: 0.254901961, blue: 0.145098039 },
    light_red1: { red: 0.878431373, green: 0.400000000, blue: 0.400000000 },
    light_orange1: { red: 0.964705882, green: 0.698039216, blue: 0.419607843 },
    light_yellow1: { red: 1.000000000, green: 0.850980392, blue: 0.400000000 },
    light_green1: { red: 0.576470588, green: 0.768627451, blue: 0.490196078 },
    light_cyan1: { red: 0.462745098, green: 0.647058824, blue: 0.686274510 },
    light_cornflower_blue1: { red: 0.427450980, green: 0.619607843, blue: 0.921568627 },
    light_blue1: { red: 0.435294118, green: 0.658823529, blue: 0.862745098 },
    light_purple1: { red: 0.556862745, green: 0.486274510, blue: 0.764705882 },
    light_magenta1: { red: 0.760784314, green: 0.482352941, blue: 0.627450980 },
    dark_red_berry1: { red: 0.650980392, green: 0.109803922, blue: 0.000000000 },
    dark_red1: { red: 0.800000000, green: 0.000000000, blue: 0.000000000 },
    dark_orange1: { red: 0.901960784, green: 0.568627451, blue: 0.219607843 },
    dark_yellow1: { red: 0.945098039, green: 0.760784314, blue: 0.196078431 },
    dark_green1: { red: 0.415686275, green: 0.658823529, blue: 0.309803922 },
    dark_cyan1: { red: 0.270588235, green: 0.505882353, blue: 0.556862745 },
    dark_cornflower_blue1: { red: 0.235294118, green: 0.470588235, blue: 0.847058824 },
    dark_blue1: { red: 0.239215686, green: 0.521568627, blue: 0.776470588 },
    dark_purple1: { red: 0.403921569, green: 0.305882353, blue: 0.654901961 },
    dark_magenta1: { red: 0.650980392, green: 0.301960784, blue: 0.474509804 },
    dark_red_berry2: { red: 0.521568627, green: 0.125490196, blue: 0.047058824 },
    dark_red2: { red: 0.600000000, green: 0.000000000, blue: 0.000000000 },
    dark_orange2: { red: 0.705882353, green: 0.372549020, blue: 0.023529412 },
    dark_yellow2: { red: 0.749019608, green: 0.564705882, blue: 0.000000000 },
    dark_green2: { red: 0.219607843, green: 0.462745098, blue: 0.113725490 },
    dark_cyan2: { red: 0.074509804, green: 0.309803922, blue: 0.360784314 },
    dark_cornflower_blue2: { red: 0.066666667, green: 0.333333333, blue: 0.800000000 },
    dark_blue2: { red: 0.043137255, green: 0.325490196, blue: 0.580392157 },
    dark_purple2: { red: 0.207843137, green: 0.109803922, blue: 0.458823529 },
    dark_magenta2: { red: 0.454901961, green: 0.105882353, blue: 0.278431373 },
    dark_red_berry3: { red: 0.356862745, green: 0.058823529, blue: 0.000000000 },
    dark_red3: { red: 0.400000000, green: 0.000000000, blue: 0.000000000 },
    dark_orange3: { red: 0.470588235, green: 0.247058824, blue: 0.015686275 },
    dark_yellow3: { red: 0.498039216, green: 0.376470588, blue: 0.000000000 },
    dark_green3: { red: 0.152941176, green: 0.305882353, blue: 0.074509804 },
    darn_cyan3: { red: 0.047058824, green: 0.203921569, blue: 0.239215686 },
    dark_cornflower_blue3: { red: 0.109803922, green: 0.270588235, blue: 0.529411765 },
    dark_blue3: { red: 0.027450980, green: 0.215686275, blue: 0.388235294 },
    dark_purple3: { red: 0.125490196, green: 0.070588235, blue: 0.301960784 },
    dark_magenta3: { red: 0.298039216, green: 0.066666667, blue: 0.188235294 },

    # Yahoo brand colors

    grape_jelly: { red: 0.376470588, green: 0.003921569, blue: 0.823529412 },
    hulk_pants: { red: 0.494117647, green: 0.121568627, blue: 1.000000000 },
    malbec: { red: 0.223529412, green: 0.000000000, blue: 0.490196078 },
    tumeric: { red: 1.000000000, green: 0.654901961, blue: 0.000000000 },
    mulah: { red: 0.101960784, green: 0.772549020, blue: 0.403921569 },
    dory: { red: 0.058823529, green: 0.411764706, blue: 1.000000000 },
    malibu: { red: 1.000000000, green: 0.000000000, blue: 0.501960784 },
    sea_foam: { red: 0.066666667, green: 0.827450980, blue: 0.803921569 },
    tumeric_tint: { red: 0.980392157, green: 0.866666667, blue: 0.694117647 },
    mulah_tint: { red: 0.733333333, green: 0.901960784, blue: 0.776470588 },
    dory_tint: { red: 0.662745098, green: 0.772549020, blue: 0.984313725 },
    malibu_tint: { red: 0.968627451, green: 0.682352941, blue: 0.800000000 },
    sea_foam_tint: { red: 0.749019608, green: 0.925490196, blue: 0.921568627 },

    # Yahoo health colors

    health_green: { red: 0.000000000, green: 0.690196078, blue: 0.313725490 },
    health_yellow: { red: 1.000000000, green: 0.654901961, blue: 0.000000000 },
    health_red: { red: 1.000000000, green: 0.000000000, blue: 0.000000000 },

    # Yahoo Fuji design color palette

    fuji_color_watermelon: { red: 1.000000000, green: 0.321568627, blue: 0.341176471 },
    fuji_color_solo_cup: { red: 0.921568627, green: 0.058823529, blue: 0.160784314 },
    fuji_color_malibu: { red: 1.000000000, green: 0.000000000, blue: 0.501960784 },
    fuji_color_barney: { red: 0.800000000, green: 0.000000000, blue: 0.549019608 },
    fuji_color_mimosa: { red: 1.000000000, green: 0.827450980, blue: 0.200000000 },
    fuji_color_turmeric: { red: 1.000000000, green: 0.654901961, blue: 0.000000000 },
    fuji_color_cheetos: { red: 0.992156863, green: 0.380392157, blue: 0.000000000 },
    fuji_color_carrot_juice: { red: 1.000000000, green: 0.321568627, blue: 0.050980392 },
    fuji_color_mulah: { red: 0.101960784, green: 0.772549020, blue: 0.403921569 },
    fuji_color_bonsai: { red: 0.000000000, green: 0.529411765, blue: 0.317647059 },
    fuji_color_spirulina: { red: 0.000000000, green: 0.627450980, blue: 0.627450980 },
    fuji_color_sea_foam: { red: 0.066666667, green: 0.827450980, blue: 0.803921569 },
    fuji_color_peeps: { red: 0.490196078, green: 0.796078431, blue: 1.000000000 },
    fuji_color_sky: { red: 0.070588235, green: 0.662745098, blue: 1.000000000 },
    fuji_color_dory: { red: 0.058823529, green: 0.411764706, blue: 1.000000000 },
    fuji_color_scooter: { red: 0.000000000, green: 0.388235294, blue: 0.921568627 },
    fuji_color_cobalt: { red: 0.000000000, green: 0.227450980, blue: 0.737254902 },
    fuji_color_denim: { red: 0.101960784, green: 0.050980392, blue: 0.670588235 },
    fuji_color_blurple: { red: 0.364705882, green: 0.368627451, blue: 1.000000000 },
    fuji_color_hendrix: { red: 0.972549020, green: 0.956862745, blue: 1.000000000 },
    fuji_color_thanos: { red: 0.564705882, green: 0.486274510, blue: 1.000000000 },
    fuji_color_starfish: { red: 0.466666667, green: 0.349019608, blue: 1.000000000 },
    fuji_color_hulk_pants: { red: 0.494117647, green: 0.121568627, blue: 1.000000000 },
    fuji_color_grape_jelly: { red: 0.376470588, green: 0.003921569, blue: 0.823529412 },
    fuji_color_mulberry: { red: 0.313725490, green: 0.082352941, blue: 0.690196078 },
    fuji_color_malbec: { red: 0.223529412, green: 0.000000000, blue: 0.490196078 },
    fuji_grayscale_black: { red: 0.000000000, green: 0.000000000, blue: 0.000000000 },
    fuji_grayscale_midnight: { red: 0.062745098, green: 0.082352941, blue: 0.094117647 },
    fuji_grayscale_inkwell: { red: 0.113725490, green: 0.133333333, blue: 0.156862745 },
    fuji_grayscale_batcave: { red: 0.137254902, green: 0.164705882, blue: 0.192156863 },
    fuji_grayscale_ramones: { red: 0.172549020, green: 0.211764706, blue: 0.247058824 },
    fuji_grayscale_charcoal: { red: 0.274509804, green: 0.305882353, blue: 0.337254902 },
    fuji_grayscale_battleship: { red: 0.356862745, green: 0.388235294, blue: 0.415686275 },
    fuji_grayscale_dolphin: { red: 0.431372549, green: 0.466666667, blue: 0.501960784 },
    fuji_grayscale_shark: { red: 0.509803922, green: 0.541176471, blue: 0.576470588 },
    fuji_grayscale_gandalf: { red: 0.592156863, green: 0.619607843, blue: 0.658823529 },
    fuji_grayscale_bob: { red: 0.690196078, green: 0.725490196, blue: 0.756862745 },
    fuji_grayscale_pebble: { red: 0.780392157, green: 0.803921569, blue: 0.823529412 },
    fuji_grayscale_dirty_seagull: { red: 0.878431373, green: 0.894117647, blue: 0.913725490 },
    fuji_grayscale_grey_hair: { red: 0.941176471, green: 0.952941176, blue: 0.960784314 },
    fuji_grayscale_marshmallow: { red: 0.960784314, green: 0.972549020, blue: 0.980392157 },
    fuji_grayscale_white: { red: 1.000000000, green: 1.000000000, blue: 1.000000000 }
  }.freeze
end
