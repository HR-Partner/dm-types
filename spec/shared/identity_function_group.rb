# frozen_string_literal: true

RSpec.shared_examples 'identity function' do
  it 'returns value unchanged' do
    @result.should == @input
  end
end
