# frozen_string_literal: true

module GgxrdDotCom
  module Models
    module Enums
      RANKS = %w[初段 2段 3段 4段 5段 6段 7段 8段 9段 10段 11段 12段 13段
                 14段 15段 16段 17段 18段 19段 20段 21段 22段 23段 24段
                 25段 賞金首 聖人 王者 暴君 闘神].map.with_index(1) {|*x| x }.to_h.freeze

      CHAR_NAMES = {
        "\u30BD\u30EB"                               => :SO, # ソル
        "\u30AB\u30A4"                               => :KY, # カイ
        "\u30E1\u30A4"                               => :MA, # メイ
        "\u30DF\u30EA\u30A2"                         => :MI, # ミリア
        "\u30B6\u30C8\u30FC"                         => :ZT, # ザトー
        "\u30DD\u30C1\u30E7\u30E0\u30AD\u30F3"       => :PO, # ポチョムキン
        "\u30C1\u30C3\u30D7"                         => :CH, # チップ
        "\u30D5\u30A1\u30A6\u30B9\u30C8"             => :FA, # ファウスト
        "\u30A2\u30AF\u30BB\u30EB"                   => :AX, # アクセル
        "\u30F4\u30A7\u30CE\u30E0"                   => :VE, # ヴェノム
        "\u30B9\u30EC\u30A4\u30E4\u30FC"             => :SL, # スレイヤー
        "\u30A4\u30CE"                               => :IN, # イノ
        "\u30D9\u30C3\u30C9\u30DE\u30F3"             => :BE, # ベッドマン
        "\u30E9\u30E0\u30EC\u30B6\u30EB"             => :RA, # ラムレザル
        "\u30B7\u30F3"                               => :SI, # シン
        "\u30A8\u30EB\u30D5\u30A7\u30EB\u30C8"       => :EL, # エルフェルト
        "\u30EC\u30AA"                               => :LE, # レオ
        "\u30B8\u30E7\u30CB\u30FC"                   => :JO, # ジョニー
        "\u30B8\u30E3\u30C3\u30AF\u30FB\u30AA\u30FC" => :JC, # ジャック・オー
        "\u7D17\u5922"                               => :JA, # 紗夢
        "\u6167\u5F26"                               => :KU, # 慧弦
        "\u30EC\u30A4\u30F4\u30F3"                   => :RV, # レイヴン
        "\u30C7\u30A3\u30BA\u30A3\u30FC"             => :DI, # ディズィー
        "\u6885\u55A7"                               => :BA, # 梅喧
        "\u30A2\u30F3\u30B5\u30FC"                   => :AN  # アンサー
      }.freeze
    end
  end
end
