require 'spec_helper'

describe ::Pando::Instance do
  subject { described_class.new(:host => 'ok', :port => 123, :guid => 'test') }

  context '#initialize' do
    it 'fails when arguments are missing' do
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new(:host => 'localhost') }.to raise_error(ArgumentError)
      expect { described_class.new(:port => 0) }.to raise_error(ArgumentError)
    end

    it 'will happily take correct instance args' do
      expect(subject.host).to eq('ok')
      expect(subject.port).to eq(123)
      expect(subject.guid).to eq('test')
    end
  end

  context 'generate_guid' do
    it 'can generate an instance guid' do
      expect(described_class.generate_guid).to include('instance-')
    end
  end

  context 'serialization' do
    let(:json) { {:host => 'ok', :port => 123, :guid => 'test'}.to_json }

    it 'can serialize to json' do
      expect(subject.serialize).to eq(json)
    end

    it 'can deserialize from json' do
      expect(described_class.deserialize(json).serialize).to eq(json)
    end
  end
end
