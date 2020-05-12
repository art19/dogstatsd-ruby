
RSpec.shared_examples 'a taggable method' do |normal_expected_result, telemetry_options,timing|
  telemetry_options ||= {}

  context 'when tags are an array of strings' do
    let(:action_tags) do
      %w[country:usa state:ny other]
    end

    it 'supports tags' do
      basic_action

      expect(socket.recv[0]).to eq_with_telemetry "#{normal_expected_result}|#country:usa,state:ny,other#{timing}", telemetry_options
    end

    context 'when there is global tags' do
      let(:tags) do
        %w[global_tag]
      end

      it 'merges global and provided tags' do
        basic_action

        expect(socket.recv[0]).to match(/^#{normal_expected_result}|#global_tag,country:usa,state:ny,other#{timing}/)
      end
    end
  end

  context 'when tags are an hash' do
    let(:action_tags) do
      {
        country: 'usa',
        state: 'ny',
      }
    end

    it 'supports tags' do
      basic_action

      expect(socket.recv[0]).to eq_with_telemetry "#{normal_expected_result}|#country:usa,state:ny#{timing}", telemetry_options
    end

    context 'when there is global tags' do
      let(:tags) do
        %w[global_tag]
      end

      it 'merges global and provided tags' do
        basic_action

        expect(socket.recv[0]).to match(/^#{normal_expected_result}|#global_tag,country:usa,state:ny/)
      end
    end
  end
end
