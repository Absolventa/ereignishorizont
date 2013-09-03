require 'spec_helper'

describe Matcher do

  context 'checking for Expected Event scopes' do
    it 'only considers Expected Events that are active' do
      pending
    end

    it 'only considers Expected Events that are valid today' do
      pending
    end

    it 'only considers Expected Events that are backward matching' do
      pending
    end
  end

  context 'matching Incoming Events' do
    it 'only considers Incoming Events that have not been tracked yet' do
      pending
    end

    it 'only considers Incoming Events that have same title as an Expected Event' do
      pending
    end

    it 'only considers Incoming Events  created today' do
      pending
    end

    it 'only considers Incoming Events created before the deadline' do
      pending
    end
  end

  context 'Incoming Event actions' do
    it 'tracks a matching Incoming Event' do
      pending
    end

    it 'sends an Alarm if an Event is not matched' do
      pending
    end
  end
end
