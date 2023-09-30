# frozen_string_literal: true

require 'json_schemer'

module SheetsV4
  # Returns predefined color objects by name
  #
  # A method is implemented for each color name. The list of available colors is
  # given by `SheetsV4.color_names`.
  #
  # @example
  #   # Get a color object by name:
  #   SheetsV4::Color.black #=> { "red" => 0.0, "green" => 0.0, "blue" => 0.0 }
  #
  # @see SheetsV4.color a method that returns a color object by name
  # @see SheetsV4.color_names an array of predefined color names
  #
  # @api public
  #
  class Color
    class << self
      # Return a color object for the given name from SheetsV4.color_names or call super
      #
      # @param method_name [#to_sym] the name of the color
      # @param arguments [Array] ignored
      # @param block [Proc] ignored
      # @return [Hash] the color object
      # @api private
      def method_missing(method_name, *arguments, &)
        COLORS[method_name.to_sym] || super
      end

      # Return true if the given method name is a color name or call super
      #
      # @param method_name [#to_sym] the name of the color
      # @param include_private [Boolean] ignored
      # @return [Boolean] true if the method name is a color name
      # @api private
      def respond_to_missing?(method_name, include_private = false)
        COLORS.key?(method_name.to_sym) || super
      end
    end

    # Colors to use in the Google Sheets API
    COLORS = {
      # Standard Google Sheets colors
      #
      black: { red: 0.00000000000, green: 0.00000000000, blue: 0.00000000000 },
      dark_gray4: { red: 0.26274509804, green: 0.26274509804, blue: 0.26274509804 },
      dark_gray3: { red: 0.40000000000, green: 0.40000000000, blue: 0.40000000000 },
      dark_gray2: { red: 0.60000000000, green: 0.60000000000, blue: 0.60000000000 },
      dark_gray1: { red: 0.71764705882, green: 0.71764705882, blue: 0.71764705882 },
      gray: { red: 0.80000000000, green: 0.80000000000, blue: 0.80000000000 },
      light_gray1: { red: 0.85098039216, green: 0.85098039216, blue: 0.85098039216 },
      light_gray2: { red: 0.93725490196, green: 0.93725490196, blue: 0.93725490196 },
      light_gray3: { red: 0.95294117647, green: 0.95294117647, blue: 0.95294117647 },
      white: { red: 1.00000000000, green: 1.00000000000, blue: 1.00000000000 },
      red_berry: { red: 0.59607843137, green: 0.00000000000, blue: 0.00000000000 },
      red: { red: 1.00000000000, green: 0.00000000000, blue: 0.00000000000 },
      orange: { red: 1.00000000000, green: 0.60000000000, blue: 0.00000000000 },
      yellow: { red: 1.00000000000, green: 1.00000000000, blue: 0.00000000000 },
      green: { red: 0.00000000000, green: 1.00000000000, blue: 0.00000000000 },
      cyan: { red: 0.00000000000, green: 1.00000000000, blue: 1.00000000000 },
      cornflower_blue: { red: 0.29019607843, green: 0.52549019608, blue: 0.90980392157 },
      blue: { red: 0.00000000000, green: 0.00000000000, blue: 1.00000000000 },
      purple: { red: 0.60000000000, green: 0.00000000000, blue: 1.00000000000 },
      magenta: { red: 1.00000000000, green: 0.00000000000, blue: 1.00000000000 },
      light_red_berry3: { red: 0.90196078431, green: 0.72156862745, blue: 0.68627450980 },
      light_red3: { red: 0.95686274510, green: 0.80000000000, blue: 0.80000000000 },
      light_orange3: { red: 0.98823529412, green: 0.89803921569, blue: 0.80392156863 },
      light_yellow3: { red: 1.00000000000, green: 0.94901960784, blue: 0.80000000000 },
      light_green3: { red: 0.85098039216, green: 0.91764705882, blue: 0.82745098039 },
      light_cyan3: { red: 0.81568627451, green: 0.87843137255, blue: 0.89019607843 },
      light_cornflower_blue3: { red: 0.78823529412, green: 0.85490196078, blue: 0.97254901961 },
      light_blue3: { red: 0.81176470588, green: 0.88627450980, blue: 0.95294117647 },
      light_purple3: { red: 0.85098039216, green: 0.82352941176, blue: 0.91372549020 },
      light_magenta3: { red: 0.91764705882, green: 0.81960784314, blue: 0.86274509804 },
      light_red_berry2: { red: 0.86666666667, green: 0.49411764706, blue: 0.41960784314 },
      light_red2: { red: 0.91764705882, green: 0.60000000000, blue: 0.60000000000 },
      light_orange2: { red: 0.97647058824, green: 0.79607843137, blue: 0.61176470588 },
      light_yellow2: { red: 1.00000000000, green: 0.89803921569, blue: 0.60000000000 },
      light_green2: { red: 0.71372549020, green: 0.84313725490, blue: 0.65882352941 },
      light_cyan2: { red: 0.63529411765, green: 0.76862745098, blue: 0.78823529412 },
      light_cornflower_blue2: { red: 0.64313725490, green: 0.76078431373, blue: 0.95686274510 },
      light_blue2: { red: 0.62352941176, green: 0.77254901961, blue: 0.90980392157 },
      light_purple2: { red: 0.70588235294, green: 0.65490196078, blue: 0.83921568627 },
      light_magenta2: { red: 0.83529411765, green: 0.65098039216, blue: 0.74117647059 },
      light_red_berry1: { red: 0.80000000000, green: 0.25490196078, blue: 0.14509803922 },
      light_red1: { red: 0.87843137255, green: 0.40000000000, blue: 0.40000000000 },
      light_orange1: { red: 0.96470588235, green: 0.69803921569, blue: 0.41960784314 },
      light_yellow1: { red: 1.00000000000, green: 0.85098039216, blue: 0.40000000000 },
      light_green1: { red: 0.57647058824, green: 0.76862745098, blue: 0.49019607843 },
      light_cyan1: { red: 0.46274509804, green: 0.64705882353, blue: 0.68627450980 },
      light_cornflower_blue1: { red: 0.42745098039, green: 0.61960784314, blue: 0.92156862745 },
      light_blue1: { red: 0.43529411765, green: 0.65882352941, blue: 0.86274509804 },
      light_purple1: { red: 0.55686274510, green: 0.48627450980, blue: 0.76470588235 },
      light_magenta1: { red: 0.76078431373, green: 0.48235294118, blue: 0.62745098039 },
      dark_red_berry1: { red: 0.65098039216, green: 0.10980392157, blue: 0.00000000000 },
      dark_red1: { red: 0.80000000000, green: 0.00000000000, blue: 0.00000000000 },
      dark_orange1: { red: 0.90196078431, green: 0.56862745098, blue: 0.21960784314 },
      dark_yellow1: { red: 0.94509803922, green: 0.76078431373, blue: 0.19607843137 },
      dark_green1: { red: 0.41568627451, green: 0.65882352941, blue: 0.30980392157 },
      dark_cyan1: { red: 0.27058823529, green: 0.50588235294, blue: 0.55686274510 },
      dark_cornflower_blue1: { red: 0.23529411765, green: 0.47058823529, blue: 0.84705882353 },
      dark_blue1: { red: 0.23921568627, green: 0.52156862745, blue: 0.77647058824 },
      dark_purple1: { red: 0.40392156863, green: 0.30588235294, blue: 0.65490196078 },
      dark_magenta1: { red: 0.65098039216, green: 0.30196078431, blue: 0.47450980392 },
      dark_red_berry2: { red: 0.52156862745, green: 0.12549019608, blue: 0.04705882353 },
      dark_red2: { red: 0.60000000000, green: 0.00000000000, blue: 0.00000000000 },
      dark_orange2: { red: 0.70588235294, green: 0.37254901961, blue: 0.02352941176 },
      dark_yellow2: { red: 0.74901960784, green: 0.56470588235, blue: 0.00000000000 },
      dark_green2: { red: 0.21960784314, green: 0.46274509804, blue: 0.11372549020 },
      dark_cyan2: { red: 0.07450980392, green: 0.30980392157, blue: 0.36078431373 },
      dark_cornflower_blue2: { red: 0.06666666667, green: 0.33333333333, blue: 0.80000000000 },
      dark_blue2: { red: 0.04313725490, green: 0.32549019608, blue: 0.58039215686 },
      dark_purple2: { red: 0.20784313725, green: 0.10980392157, blue: 0.45882352941 },
      dark_magenta2: { red: 0.45490196078, green: 0.10588235294, blue: 0.27843137255 },
      dark_red_berry3: { red: 0.35686274510, green: 0.05882352941, blue: 0.00000000000 },
      dark_red3: { red: 0.40000000000, green: 0.00000000000, blue: 0.00000000000 },
      dark_orange3: { red: 0.47058823529, green: 0.24705882353, blue: 0.01568627451 },
      dark_yellow3: { red: 0.49803921569, green: 0.37647058824, blue: 0.00000000000 },
      dark_green3: { red: 0.15294117647, green: 0.30588235294, blue: 0.07450980392 },
      darn_cyan3: { red: 0.04705882353, green: 0.20392156863, blue: 0.23921568627 },
      dark_cornflower_blue3: { red: 0.10980392157, green: 0.27058823529, blue: 0.52941176471 },
      dark_blue3: { red: 0.02745098039, green: 0.21568627451, blue: 0.38823529412 },
      dark_purple3: { red: 0.12549019608, green: 0.07058823529, blue: 0.30196078431 },
      dark_magenta3: { red: 0.29803921569, green: 0.06666666667, blue: 0.18823529412 },

      # Yahoo brand colors
      #
      grape_jelly: { red: 0.37647058824, green: 0.00392156863, blue: 0.82352941176 },
      hulk_pants: { red: 0.49411764706, green: 0.12156862745, blue: 1.00000000000 },
      malbec: { red: 0.22352941176, green: 0.00000000000, blue: 0.49019607843 },
      tumeric: { red: 1.00000000000, green: 0.65490196078, blue: 0.00000000000 },
      mulah: { red: 0.10196078431, green: 0.77254901961, blue: 0.40392156863 },
      dory: { red: 0.05882352941, green: 0.41176470588, blue: 1.00000000000 },
      malibu: { red: 1.00000000000, green: 0.00000000000, blue: 0.50196078431 },
      sea_foam: { red: 0.06666666667, green: 0.82745098039, blue: 0.80392156863 },
      tumeric_tint: { red: 0.98039215686, green: 0.86666666667, blue: 0.69411764706 },
      mulah_tint: { red: 0.73333333333, green: 0.90196078431, blue: 0.77647058824 },
      dory_tint: { red: 0.66274509804, green: 0.77254901961, blue: 0.98431372549 },
      malibu_tint: { red: 0.96862745098, green: 0.68235294118, blue: 0.80000000000 },
      sea_foam_tint: { red: 0.74901960784, green: 0.92549019608, blue: 0.92156862745 },

      # Yahoo health colors
      #
      health_green: { red: 0.00000000000, green: 0.69019607843, blue: 0.31372549020 },
      health_yellow: { red: 1.00000000000, green: 0.65490196078, blue: 0.00000000000 },
      health_red: { red: 1.00000000000, green: 0.00000000000, blue: 0.00000000000 },

      # Yahoo Fuji design color palette
      #
      fuji_color_watermelon: { red: 1.00000000000, green: 0.32156862745, blue: 0.34117647059 },
      fuji_color_solo_cup: { red: 0.92156862745, green: 0.05882352941, blue: 0.16078431373 },
      fuji_color_malibu: { red: 1.00000000000, green: 0.00000000000, blue: 0.50196078431 },
      fuji_color_barney: { red: 0.80000000000, green: 0.00000000000, blue: 0.54901960784 },
      fuji_color_mimosa: { red: 1.00000000000, green: 0.82745098039, blue: 0.20000000000 },
      fuji_color_turmeric: { red: 1.00000000000, green: 0.65490196078, blue: 0.00000000000 },
      fuji_color_cheetos: { red: 0.99215686275, green: 0.38039215686, blue: 0.00000000000 },
      fuji_color_carrot_juice: { red: 1.00000000000, green: 0.32156862745, blue: 0.05098039216 },
      fuji_color_mulah: { red: 0.10196078431, green: 0.77254901961, blue: 0.40392156863 },
      fuji_color_bonsai: { red: 0.00000000000, green: 0.52941176471, blue: 0.31764705882 },
      fuji_color_spirulina: { red: 0.00000000000, green: 0.62745098039, blue: 0.62745098039 },
      fuji_color_sea_foam: { red: 0.06666666667, green: 0.82745098039, blue: 0.80392156863 },
      fuji_color_peeps: { red: 0.49019607843, green: 0.79607843137, blue: 1.00000000000 },
      fuji_color_sky: { red: 0.07058823529, green: 0.66274509804, blue: 1.00000000000 },
      fuji_color_dory: { red: 0.05882352941, green: 0.41176470588, blue: 1.00000000000 },
      fuji_color_scooter: { red: 0.00000000000, green: 0.38823529412, blue: 0.92156862745 },
      fuji_color_cobalt: { red: 0.00000000000, green: 0.22745098039, blue: 0.73725490196 },
      fuji_color_denim: { red: 0.10196078431, green: 0.05098039216, blue: 0.67058823529 },
      fuji_color_blurple: { red: 0.36470588235, green: 0.36862745098, blue: 1.00000000000 },
      fuji_color_hendrix: { red: 0.97254901961, green: 0.95686274510, blue: 1.00000000000 },
      fuji_color_thanos: { red: 0.56470588235, green: 0.48627450980, blue: 1.00000000000 },
      fuji_color_starfish: { red: 0.46666666667, green: 0.34901960784, blue: 1.00000000000 },
      fuji_color_hulk_pants: { red: 0.49411764706, green: 0.12156862745, blue: 1.00000000000 },
      fuji_color_grape_jelly: { red: 0.37647058824, green: 0.00392156863, blue: 0.82352941176 },
      fuji_color_mulberry: { red: 0.31372549020, green: 0.08235294118, blue: 0.69019607843 },
      fuji_color_malbec: { red: 0.22352941176, green: 0.00000000000, blue: 0.49019607843 },
      fuji_grayscale_black: { red: 0.00000000000, green: 0.00000000000, blue: 0.00000000000 },
      fuji_grayscale_midnight: { red: 0.06274509804, green: 0.08235294118, blue: 0.09411764706 },
      fuji_grayscale_inkwell: { red: 0.11372549020, green: 0.13333333333, blue: 0.15686274510 },
      fuji_grayscale_batcave: { red: 0.13725490196, green: 0.16470588235, blue: 0.19215686275 },
      fuji_grayscale_ramones: { red: 0.17254901961, green: 0.21176470588, blue: 0.24705882353 },
      fuji_grayscale_charcoal: { red: 0.27450980392, green: 0.30588235294, blue: 0.33725490196 },
      fuji_grayscale_battleship: { red: 0.35686274510, green: 0.38823529412, blue: 0.41568627451 },
      fuji_grayscale_dolphin: { red: 0.43137254902, green: 0.46666666667, blue: 0.50196078431 },
      fuji_grayscale_shark: { red: 0.50980392157, green: 0.54117647059, blue: 0.57647058824 },
      fuji_grayscale_gandalf: { red: 0.59215686275, green: 0.61960784314, blue: 0.65882352941 },
      fuji_grayscale_bob: { red: 0.69019607843, green: 0.72549019608, blue: 0.75686274510 },
      fuji_grayscale_pebble: { red: 0.78039215686, green: 0.80392156863, blue: 0.82352941176 },
      fuji_grayscale_dirty_seagull: { red: 0.87843137255, green: 0.89411764706, blue: 0.91372549020 },
      fuji_grayscale_grey_hair: { red: 0.94117647059, green: 0.95294117647, blue: 0.96078431373 },
      fuji_grayscale_marshmallow: { red: 0.96078431373, green: 0.97254901961, blue: 0.98039215686 },
      fuji_grayscale_white: { red: 1.00000000000, green: 1.00000000000, blue: 1.00000000000 }
    }.freeze.each_value(&:freeze)
  end
end
