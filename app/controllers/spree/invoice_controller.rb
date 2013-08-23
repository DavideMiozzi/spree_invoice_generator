module Spree
  class InvoiceController < BaseController

    def show
      order_id = params[:order_id].to_i
      @order = Order.find_by_id(order_id)
      @address = @order.bill_address
      @invoice_print = Spree::Invoice.find_or_create_by_order_id(order_id)
      if @invoice_print
        respond_to do |format|
          format.pdf  {
            @as_html = false 
            send_data @invoice_print.generate_pdf, :filename => "#{@invoice_print.invoice_number}.pdf", :type => 'application/pdf' }
          format.html { 
            @as_html = true 
            render :file => SpreeInvoice.invoice_template_path.to_s, :layout => false }
        end
      else
        if spree_current_user.has_spree_role?(:admin)
          return redirect_to(admin_orders_path, :notice => t(:no_such_order_found, :scope => :spree))
        else
          return redirect_to(orders_path, :alert => t(:no_such_order_found, :scope => :spree))
        end
      end
    end
  end
end
