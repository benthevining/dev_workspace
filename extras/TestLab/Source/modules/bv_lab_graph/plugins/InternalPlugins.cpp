
#include <juce_audio_plugin_client/juce_audio_plugin_client.h>

#include "InternalPlugins.h"
#include "PluginGraph.h"

#include "../../../../examples/Plugins/AUv3SynthPluginDemo.h"
#include "../../../../examples/Plugins/ArpeggiatorPluginDemo.h"
#include "../../../../examples/Plugins/AudioPluginDemo.h"
#include "../../../../examples/Plugins/DSPModulePluginDemo.h"
#include "../../../../examples/Plugins/GainPluginDemo.h"
#include "../../../../examples/Plugins/MidiLoggerPluginDemo.h"
#include "../../../../examples/Plugins/MultiOutSynthPluginDemo.h"
#include "../../../../examples/Plugins/NoiseGatePluginDemo.h"
#include "../../../../examples/Plugins/SamplerPluginDemo.h"
#include "../../../../examples/Plugins/SurroundPluginDemo.h"

//==============================================================================
class InternalPlugin : public AudioPluginInstance
{
public:
    explicit InternalPlugin (std::unique_ptr< AudioProcessor > innerIn)
        : inner (std::move (innerIn))
    {
        jassert (inner != nullptr);

        for (auto isInput : {true, false})
            matchChannels (isInput);

        setBusesLayout (inner->getBusesLayout());
    }

    //==============================================================================
    const String          getName() const override { return inner->getName(); }
    StringArray           getAlternateDisplayNames() const override { return inner->getAlternateDisplayNames(); }
    double                getTailLengthSeconds() const override { return inner->getTailLengthSeconds(); }
    bool                  acceptsMidi() const override { return inner->acceptsMidi(); }
    bool                  producesMidi() const override { return inner->producesMidi(); }
    AudioProcessorEditor* createEditor() override { return inner->createEditor(); }
    bool                  hasEditor() const override { return inner->hasEditor(); }
    int                   getNumPrograms() override { return inner->getNumPrograms(); }
    int                   getCurrentProgram() override { return inner->getCurrentProgram(); }
    void                  setCurrentProgram (int i) override { inner->setCurrentProgram (i); }
    const String          getProgramName (int i) override { return inner->getProgramName (i); }
    void                  changeProgramName (int i, const String& n) override { inner->changeProgramName (i, n); }
    void                  getStateInformation (juce::MemoryBlock& b) override { inner->getStateInformation (b); }
    void                  setStateInformation (const void* d, int s) override { inner->setStateInformation (d, s); }
    void                  getCurrentProgramStateInformation (juce::MemoryBlock& b) override { inner->getCurrentProgramStateInformation (b); }
    void                  setCurrentProgramStateInformation (const void* d, int s) override { inner->setCurrentProgramStateInformation (d, s); }
    void                  prepareToPlay (double sr, int bs) override
    {
        inner->setRateAndBufferSizeDetails (sr, bs);
        inner->prepareToPlay (sr, bs);
    }
    void releaseResources() override { inner->releaseResources(); }
    void memoryWarningReceived() override { inner->memoryWarningReceived(); }
    void processBlock (AudioBuffer< float >& a, MidiBuffer& m) override { inner->processBlock (a, m); }
    void processBlock (AudioBuffer< double >& a, MidiBuffer& m) override { inner->processBlock (a, m); }
    void processBlockBypassed (AudioBuffer< float >& a, MidiBuffer& m) override { inner->processBlockBypassed (a, m); }
    void processBlockBypassed (AudioBuffer< double >& a, MidiBuffer& m) override { inner->processBlockBypassed (a, m); }
    bool supportsDoublePrecisionProcessing() const override { return inner->supportsDoublePrecisionProcessing(); }
    bool supportsMPE() const override { return inner->supportsMPE(); }
    bool isMidiEffect() const override { return inner->isMidiEffect(); }
    void reset() override { inner->reset(); }
    void setNonRealtime (bool b) noexcept override { inner->setNonRealtime (b); }
    void refreshParameterList() override { inner->refreshParameterList(); }
    void numChannelsChanged() override { inner->numChannelsChanged(); }
    void numBusesChanged() override { inner->numBusesChanged(); }
    void processorLayoutsChanged() override { inner->processorLayoutsChanged(); }
    void setPlayHead (AudioPlayHead* p) override { inner->setPlayHead (p); }
    void updateTrackProperties (const TrackProperties& p) override { inner->updateTrackProperties (p); }
    bool isBusesLayoutSupported (const BusesLayout& layout) const override { return inner->checkBusesLayoutSupported (layout); }

    bool canAddBus (bool) const override { return true; }
    bool canRemoveBus (bool) const override { return true; }

    //==============================================================================
    void fillInPluginDescription (PluginDescription& description) const override
    {
        description = getPluginDescription (*inner);
    }

private:
    static PluginDescription getPluginDescription (const AudioProcessor& proc)
    {
        const auto ins                 = proc.getTotalNumInputChannels();
        const auto outs                = proc.getTotalNumOutputChannels();
        const auto identifier          = proc.getName();
        const auto registerAsGenerator = ins == 0;
        const auto acceptsMidi         = proc.acceptsMidi();

        PluginDescription descr;

        descr.name              = identifier;
        descr.descriptiveName   = identifier;
        descr.pluginFormatName  = InternalPluginFormat::getIdentifier();
        descr.category          = (registerAsGenerator ? (acceptsMidi ? "Synth" : "Generator") : "Effect");
        descr.manufacturerName  = "JUCE";
        descr.version           = ProjectInfo::versionString;
        descr.fileOrIdentifier  = identifier;
        descr.isInstrument      = (acceptsMidi && registerAsGenerator);
        descr.numInputChannels  = ins;
        descr.numOutputChannels = outs;

        descr.uniqueId = descr.deprecatedUid = identifier.hashCode();

        return descr;
    }

    void matchChannels (bool isInput)
    {
        const auto inBuses = inner->getBusCount (isInput);

        while (getBusCount (isInput) < inBuses)
            addBus (isInput);

        while (inBuses < getBusCount (isInput))
            removeBus (isInput);
    }

    std::unique_ptr< AudioProcessor > inner;

    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (InternalPlugin)
};

//==============================================================================

InternalPluginFormat::InternalPluginFactory::InternalPluginFactory (const std::initializer_list< Constructor >& constructorsIn)
    : constructors (constructorsIn),
      descriptions ([&]
                    {
                        std::vector< PluginDescription > result;

                        for (const auto& constructor : constructors)
                            result.push_back (constructor()->getPluginDescription());

                        return result;
                    }())
{
}

std::unique_ptr< AudioPluginInstance > InternalPluginFormat::InternalPluginFactory::createInstance (const String& name) const
{
    const auto begin = descriptions.begin();
    const auto it    = std::find_if (begin,
                                  descriptions.end(),
                                  [&] (const PluginDescription& desc)
                                  { return name.equalsIgnoreCase (desc.name); });

    if (it == descriptions.end())
        return nullptr;

    const auto index = (size_t) std::distance (begin, it);
    return constructors[index]();
}

InternalPluginFormat::InternalPluginFormat()
    : factory {
        []
        { return std::make_unique< AudioProcessorGraph::AudioGraphIOProcessor > (AudioProcessorGraph::AudioGraphIOProcessor::audioInputNode); },
        []
        { return std::make_unique< AudioProcessorGraph::AudioGraphIOProcessor > (AudioProcessorGraph::AudioGraphIOProcessor::midiInputNode); },
        []
        { return std::make_unique< AudioProcessorGraph::AudioGraphIOProcessor > (AudioProcessorGraph::AudioGraphIOProcessor::audioOutputNode); },
        []
        { return std::make_unique< AudioProcessorGraph::AudioGraphIOProcessor > (AudioProcessorGraph::AudioGraphIOProcessor::midiOutputNode); },

        []
        { return std::make_unique< InternalPlugin > (std::make_unique< SineWaveSynth >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< ReverbPlugin >()); },

        []
        { return std::make_unique< InternalPlugin > (std::make_unique< AUv3SynthProcessor >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< Arpeggiator >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< DspModulePluginDemoAudioProcessor >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< GainProcessor >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< JuceDemoPluginAudioProcessor >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< MidiLoggerPluginDemoProcessor >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< MultiOutSynth >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< NoiseGate >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< SamplerAudioProcessor >()); },
        []
        { return std::make_unique< InternalPlugin > (std::make_unique< SurroundProcessor >()); }}
{
}

std::unique_ptr< AudioPluginInstance > InternalPluginFormat::createInstance (const String& name)
{
    return factory.createInstance (name);
}

void InternalPluginFormat::createPluginInstance (const PluginDescription& desc,
                                                 double /*initialSampleRate*/, int /*initialBufferSize*/,
                                                 PluginCreationCallback callback)
{
    if (auto p = createInstance (desc.name))
        callback (std::move (p), {});
    else
        callback (nullptr, NEEDS_TRANS ("Invalid internal plugin name"));
}

bool InternalPluginFormat::requiresUnblockedMessageThreadDuringCreation (const PluginDescription&) const
{
    return false;
}

const std::vector< PluginDescription >& InternalPluginFormat::getAllTypes() const
{
    return factory.getDescriptions();
}
