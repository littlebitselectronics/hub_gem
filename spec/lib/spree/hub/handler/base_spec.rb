require 'spec_helper'

module Spree
  module Hub
    describe Handler::Base do

      context "#initialize" do

        let(:sample_request) {::Hub::Samples::Order.request}
        let(:base_handler) {Handler::Base.new(sample_request.to_json)}

        it "will set the request_id" do
          expect(base_handler.request_id).to_not be_nil
        end

        context "with message without parameters" do
          it "will set the parameters as an empty hash" do
            expect(base_handler.parameters).to be_empty
          end
        end

        context "with message that has parameters" do

          let(:params) { {"key1" => "value1", "key2" => "value2"} }
          let(:sample_request) {::Hub::Samples::Order.request.merge({"parameters" => params})}

          it "will set the correct parameters" do
            expect(base_handler.parameters).to eql params
          end
        end

      end

      context "#build_handler" do

        context "for add_order" do
          it "will return the addOrderHandler" do
            expect(Handler::Base.build_handler("add_order", ::Hub::Samples::Order.request.to_json).class.name).to eql "Spree::Hub::Handler::AddOrderHandler"
          end
        end

        context "for update_order" do
          it "will return the updateOrderHandler" do
            expect(Handler::Base.build_handler("update_order", ::Hub::Samples::Order.request.to_json).class.name).to eql "Spree::Hub::Handler::UpdateOrderHandler"
          end
        end

        context "for set_inventory" do
          it "will return the SetInventoryHandler" do
            expect(Handler::Base.build_handler("set_inventory", ::Hub::Samples::Inventory.request.to_json).class.name).to eql "Spree::Hub::Handler::SetInventoryHandler"
          end
        end

      end
    end
  end
end
