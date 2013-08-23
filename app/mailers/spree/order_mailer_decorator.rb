module Spree
  OrderMailer.class_eval do
    
    def confirm_email(order, resend = false)
      if SpreeInvoice.on_confirm_email && !SpreeInvoice.except_payment.include?(order.payment_method.type)
        inv_print = Spree::Invoice.find_or_create_by_order_id(order.id)
        attachments["#{inv_print.invoice_number}.pdf"] = {
          :content => inv_print.generate_pdf,
          :mime_type => 'application/pdf'
        } if inv_print
      end
      @order = order
      subject = (resend ? "[#{t(:resend).upcase}] " : "")
      subject += "#{Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{order.number}"
      mail(:to => order.email, :subject => subject)
    end
  end
end