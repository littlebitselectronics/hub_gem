require 'active_model/serializer'

module Spree
  module Hub
    class OrderSerializer < ActiveModel::Serializer

      attributes :id, :status, :channel, :email, :currency, :placed_on, :totals

      has_many :line_items,  serializer: Spree::Hub::LineItemSerializer
      has_many :adjustments, serializer: Spree::Hub::AdjustmentSerializer
      # has_many :payments
      #
      # has_one :shipping_address
      # has_one :billing_address

      def id
        object.number
      end

      def status
        object.state
      end

      def placed_on
        object.completed? ? object.completed_at.iso8601 : nil
      end

      def totals
        {
          item: object.item_total.to_f,
          adjustment: object.adjustment_total.to_f,
          tax: (object.included_tax_total + object.additional_tax_total).to_f,
          shipping: object.shipment_total.to_f,
          payment: object.payments.completed.sum(:amount).to_f,
          order: object.total.to_f
        }
      end

    end
  end
end
