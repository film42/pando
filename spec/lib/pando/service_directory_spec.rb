require 'spec_helper'

describe ::Pando::ServiceDirectory do
  before(:each) do
    # Eww
    described_class.client = double("zk")
  end

  context 'announce' do
    it 'can announce an instance to zookeeper' do
      instance = ::Pando::Instance.new(:host => 'lol', :port => '432')

      allow(subject.client).to receive(:mkdir_p)
        .with('/default/services/things')

      allow(subject.client).to receive(:create)
        .with("/default/services/things/#{instance.guid}", instance.serialize, :ephemeral => true)

      expect(subject.announce(:resource => :things, :instances => [instance]))
    end

    it 'fails when arguments are missing' do
      expect { subject.announce }.to raise_error(ArgumentError)
      expect { subject.announce(:resource => :things) }.to raise_error(ArgumentError)
      expect { subject.announce(:instances => nil) }.to raise_error(ArgumentError)
      expect { subject.announce(:instances => []) }.to raise_error(ArgumentError)
    end
  end

  context 'instance_for' do
    it 'can receive an instance from zookeeper' do
      allow(subject.client).to receive(:children)
        .with('/default/services/things')
        .and_return(['guid-1'])

      allow(subject.client).to receive(:get)
        .with('/default/services/things/guid-1')
        .and_return(['{"host":"hi","port":123,"guid":"guid-1"}', nil])

      expect(subject.instance_for(:things).host).to eq('hi')
      expect(subject.instance_for(:things).port).to eq(123)
      expect(subject.instance_for(:things).guid).to eq('guid-1')
    end

    it 'raises an error when no instances are available' do
      allow(subject.client).to receive(:children)
        .with('/default/services/things')
        .and_return([])

      expect { subject.instance_for(:things) }.to raise_error(::Pando::NoInstancesAvailableError)
    end

    it 'fails when arguments are missing' do
      expect { subject.instance_for(nil) }.to raise_error(ArgumentError)
    end
  end

  context '#base_path' do
    it 'creates a valid base path' do
      expect(subject.base_path).to eq('/default/services')
    end
  end
end
