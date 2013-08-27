module Spree
  OrderMailer.class_eval do
    
    def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      if SpreeInvoice.on_confirm_email && !@order.nil?
        inv_print = Spree::Invoice.find_or_create_by_order_id(order)
        attachments["#{inv_print.invoice_number}.pdf"] = {
          :content => inv_print.generate_pdf,
          :mime_type => 'application/pdf'
        } if inv_print
      end
      subject = (resend ? "[#{t(:resend).upcase}] " : "")
      subject += "#{Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"
      mail(to: @order.email, from: from_address, subject: subject)
    end
  end
end