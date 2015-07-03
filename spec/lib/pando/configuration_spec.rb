require 'spec_helper'

describe ::Pando::Configuration do
  describe 'default values' do
    specify { expect(subject.host).to eq('localhost') }
    specify { expect(subject.port).to eq(2181) }
    specify { expect(subject.environment).to eq('default') }
  end
end
