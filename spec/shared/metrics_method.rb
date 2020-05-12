
RSpec.shared_examples 'a metrics method' do |normal_expected_result, telemetry_options|
  let(:action_tags) do
    []
  end

  it_behaves_like 'a namespaceable method', normal_expected_result
  it_behaves_like 'a log debuggable method', normal_expected_result
  it_behaves_like 'a taggable method', normal_expected_result, telemetry_options
end

RSpec.shared_examples 'a metrics method with timing' do |normal_expected_result, telemetry_options|
  let(:action_tags) { [] }

  it_behaves_like 'a namespaceable method', "#{normal_expected_result}|#un:ms"

  it_behaves_like 'a log debuggable method', "#{normal_expected_result}|#un:ms"

  it_behaves_like 'a taggable method', normal_expected_result, telemetry_options, ',un:ms'
end
