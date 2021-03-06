## musikov

Random midi generator based on Markov Chains. (Make heavy use of [Midilib](https://github.com/jimm/midilib))

The model is quite simple: from a set of songs, a |Note, Duration| graph will be generated where the edges will indicate the probability of transitions between two of these states. A graph will be generated for each instrument on the input set of midifiles.

A song is generated randomically from an inital state, picking the subsequent states according the indicated probability.

More inform about Markov Chains : http://en.wikipedia.org/wiki/Markov_chain

## Installation

### RubyGems instalation

```bash
gem install musikov
```

or, in order to update the gem:

```bash
gem update musikov
```

You may need root privileges to install the gem.

## How to use it

First launch the musikov passing a midi file, or a folder containg midi files, as the main argument:

    $ musikov generate -r path-to-midis [-o output_file]

The musikov will output a random midi file named output.mid (by default), or the indicated file if the option '-o' is used.

## TODO

 - Define an option for the duration of the songs by time or by number of notes.
 - Maybe classify different sacles in order to aproximate a generated song to the predominant scale.

## Author

Andre Fonseca <andre.amorimfonseca@gmail.com>

## License

Simplified BSD
