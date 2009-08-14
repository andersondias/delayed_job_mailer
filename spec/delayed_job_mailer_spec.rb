require File.dirname(__FILE__) + '/spec_helper'

require 'rubygems'
gem     'actionmailer'
require 'actionmailer'

ActionMailer::Base.delivery_method = :test

class AsynchTestMailer < ActionMailer::Base
  include Delayed::AsynchMailer
  
  def test_mail(from, to)
    @subject    = 'subject'
    @body       = 'mail body'
    @recipients = to
    @from       = from
    @sent_on    = Time.now
    @headers    = {}
  end
end

describe AsynchTestMailer do
  describe 'deliver_test_mail' do
    before(:each) do
      @emails = ActionMailer::Base.deliveries
      @emails.clear
      @params = 'noreply@autoki.de', 'joe@doe.com'
      AsynchTestMailer.stub(:send_later)
    end

    it 'should not deliver the email at this moment' do
      AsynchTestMailer.deliver_test_mail *@params
      @emails.size.should == 0
    end

    it 'should send deliver action to delayed job list' do
      AsynchTestMailer.should_receive(:send_later).with(:deliver_test_mail, *@params)
      AsynchTestMailer.deliver_test_mail *@params
    end
  end

  describe 'deliver_test_mail!' do
    it 'should deliver the mail' do
      emails = ActionMailer::Base.deliveries
      emails.clear
      AsynchTestMailer.deliver_test_mail! 'noreply@autoki.de', 'joe@doe.com'
      emails.size.should == 1
    end
  end
end
