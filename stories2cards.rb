# Adapted from http://github.com/brynary/features2cards/blob/master/lib/features2cards/prawn.rb
#
# * Changed font to DejaVuSans (default Helvetica fucks up non-ASCII chars)
# * Tweaked font size
# * Tweaked margins

class Prawn::Document
  CARD_WIDTH  = 72 * 5 # 5 inches
  CARD_HEIGHT = 72 * 3 # 3 inches

  def self.generate_cards(outfile, cards)
    generate(outfile,
      :page_layout   => :landscape,
      :margin => 50,
      :page_size => 'A4') do

      font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
      
      row = 2
      col = 0

      cards.each do |card|
        if row == 0
          start_new_page
          row = 2
          col = 0
        end

        draw_card(card, row, col)

        col += 1

        if col > 1
          col = 0
          row -= 1
        end
      end
    end
  end

  def margin_box(margin, &block)
    bounding_box [bounds.left + margin, bounds.top - margin],
      :width => bounds.width - (margin * 2), :height => bounds.height - (margin * 2),
      &block
  end

  def draw_card(card, row, col)
    bounding_box [CARD_WIDTH * col, CARD_HEIGHT * row + ((bounds.height - (2*CARD_HEIGHT))/2)],
      :width => CARD_WIDTH, :height => CARD_HEIGHT do

      stroke_bounds

      margin_box 8 do
        text card.title, :size => 14

        margin_box 32 do
          text card.body, :size => 10, :align => :left
        end

        unless card.type.nil?
          bounding_box [bounds.left, bounds.bottom + 10], :width => bounds.width, :height => 10 do
            text card.type, :size => 8, :align => :right
          end
        end
      end
    end
  end

end
