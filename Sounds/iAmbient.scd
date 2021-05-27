s.boot()

// sounds
(
SynthDef.new(\test, {
	// fund
	// evaluate the function 12 times
	arg fund = 800;
    var n = 6, out;
    out = Mix.fill(
        n,
        {
			SinOsc.ar([fund, 67.rrand(1000)], 0, n.reciprocal * 0.1);
        }
    )*EnvGen.kr(Env.perc(0.5, 1), doneAction: Done.freeSelf);
	Out.ar(0, Pan2.ar(out));
}
).play;
)

(
SynthDef.new(\tone, {
	arg freq = 440, outBus = 0, effectBus, direction = 0.5;
	var osc1, osc2, osc3, env, out;
	env = EnvGen.kr(Env.new([0,1,0],[0.01, 0.1], [1,-1]), LFSaw.kr(0.5));

	osc1 = LFTri.ar(freq, mul:0.5);
	osc2 = LFPar.ar(freq*2, mul:0.1);
	osc3 = SinOsc.ar(freq*3, mul:0.05);

	out = (osc1 + osc2 + osc3)*env;

	// Output
	Out.ar(outBus, out*direction);
	// Effect
	Out.ar(effectBus, out*(1-direction));
}
).send(s);
)

(
SynthDef.new(\water,{
	// we want to control fund and speed
	arg outBus = 0, effectBus, direction = 0.5, fund = 800, speed = 80;
	var trigs, freq, osc1, osc2, osc3, out;

		trigs = Dust.kr(speed);
		freq =
			// Generally choose from a varied base freq
			TExpRand.kr(fund, fund + 700, trigs)
			// Wobbly variation
			+ LFNoise2.kr(20, mul: 300)
			// General tendency for upward rise
			+ EnvGen.kr(Env.perc(1).range(0,17), trigs);

	osc1 = SinOsc.ar(freq, 0, 0.05);
	osc2 = SinOsc.ar(freq/2, 0, 0.03);
	osc3 = SinOsc.ar(freq*1.5, 0, 0.01);
	out = osc1 + osc2 + PinkNoise.ar(mul:0.03, add: Saw.kr(0.5));

	// Output
	Out.ar(outBus, Pan2.ar(out*direction, pos:0));
	// Effect
	Out.ar(effectBus, Pan2.ar(out*(1-direction), pos:0));
}
).send(s);
)

(
SynthDef(\organo, {
	// freq
	arg out= 0, pan= 0, freq= 400, amp= 0.1;
	var amps= [1, 0.67, 1, 1.8, 2.67, 1.67];
	var dets= [0, 1, 0, 1.7, 0, 0];    // Detune
	// Mix.fill(n,function) n= size of array to create, function: array filling function
	var src= Mix.fill(6, {
		arg i;
		var env = EnvGen.ar(Env.asr);
		LFTri.ar(freq*i/4 + dets[i], 0, amp*env);
	});
	Out.ar(out, Pan2.ar(src, pan));
}).add;
)

y = Synth.new(\organo);
y.set(\freq, 200);
y.set(\pan, 0.5);

//computer sound
(
SynthDef.new(\blipblop, {
	arg period = 0.05, mille = 2000;
	var change, rate, sig, carrierFreq, cfRamp, carrierLvl, clRamp,
	modulatorRatio, mrRamp, modulatorIndex, miRamp, outputAmplitude, oaRamp;

	period = period * 600 + 100;

	// Calculation of a recursive working metronome (Impulse.kr) that generates its
	// changing frequency out of its own impulses.
	change = Impulse.kr(LocalIn.kr(1,10));
	rate = CoinGate.kr(1/3, change);
	rate = (TChoose.kr(rate, period/((0..1) + 1))/1000).reciprocal;
	LocalOut.kr(rate);

	# carrierFreq, cfRamp = TIRand.kr(0, [mille, 1], change);
	carrierFreq = Ramp.kr( carrierFreq / mille, (cfRamp * period) / mille ) * 0.6;

	# carrierLvl, clRamp = TIRand.kr(0, [9000, 1], CoinGate.kr(1/3, change));
	carrierLvl = Ramp.kr( carrierLvl, (clRamp * period) / 1000) + 100;

	# modulatorRatio, mrRamp = TIRand.kr([800,1], CoinGate.kr(1/4, change));
	modulatorRatio = Ramp.kr(modulatorRatio, (mrRamp * period) / 1000) + 20;

	# modulatorIndex, miRamp = TIRand.kr(0, [100, 1], CoinGate.kr(1/4, change));
	modulatorIndex = Ramp.kr(modulatorIndex / 200, (miRamp * period) / 1000) + 0.2;

	# outputAmplitude, oaRamp = TIRand.kr(0!2, 1!2, CoinGate.kr(1/2, change));
	outputAmplitude = Ramp.kr(outputAmplitude, (oaRamp * period + 3) / 1000);

	// jointed FM Synthesizer
	sig = LFSaw.ar(carrierFreq, 1, 0.5, 0.5) * carrierLvl;
	sig = sig + SinOsc.ar(carrierFreq * modulatorRatio) * modulatorIndex;
	sig = cos(sig * 2pi) * outputAmplitude;

	// One pole filters:
	sig = OnePole.ar(sig, exp(-2pi * (10000 * SampleDur.ir)));
	sig = OnePole.ar(sig, exp(-2pi * (10000 * SampleDur.ir)));
	sig = (sig - OnePole.ar(sig, exp(-2pi * (100 * SampleDur.ir))));
	sig = (sig - OnePole.ar(sig, exp(-2pi * (100 * SampleDur.ir))));
	sig = sig!2 * 0.06;
	Out.ar(0, Pan2.ar(sig, pos:0));
}
).play;
)

Synth.new(\blipblop);

//effects

(
SynthDef(\reverb,{
	arg outBus = 0, inBus;
	var input;

	input = In.ar(inBus, 1);

	// 16 decaying pulses, position is determined randomly each with decay time of 3 seconds
	// 16.do allow to repeat the computation for 16 times
	// AllpassC is an all pass delay line with cubic interpolation
	// dup is used to get a stereo output (2 by default)

	16.do({input = AllpassC.ar(in:input, maxdelaytime:0.04, delaytime:{Rand(0.001,0.04)}.dup, decaytime:3)});

	Out.ar(outBus, input);

}).send(s);
)


(
SynthDef(\dubecho,{
	arg length = 1, fb = 0.8, sep = 0.01;
	arg outBus = 0, inBus;
	var input, output;

	input = In.ar(inBus, 2);
	output = input + Fb({

		arg feedback; // this will contain the delayed output from the Fb unit

		var left,right;
		var magic = LeakDC.ar(feedback*fb + input);

		magic = HPF.ar(magic, 400); // filter's on the feedback path
		magic = LPF.ar(magic, 5000);
		magic = magic.tanh; // and some more non-linearity in the form of distortion
		#left, right = magic; // let's have named variables for the left and right channels
		magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1,    LFNoise2.ar(12).range(sep,0))];
		// In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

},length);
Out.ar(outBus, output);
}).send(s);
)


/*

In a Flanger, a delayed signal is added to the original signal with a continuously-variable delay (usually smaller than 10 ms) creating a phasing effect. The term comes from times where tapes were used in studios and an operator would place the finger on the flange of one of the tapes to slow it down, thus causing the flanging effect.


Flanger is like a Phaser with dynamic delay filter (allpass), but usually it has a feedback loop.

*/


(
SynthDef(\flanger, {
	arg out=0, in=0, delay=0.1, depth=0.08, rate=0.06, fdbk=0.0, decay=0.0;
	var input, maxdelay, maxrate, dsig, mixed, local;
	maxdelay = 0.013;
	maxrate = 10.0;

	input = In.ar(in, 1);
	local = LocalIn.ar(1);

	dsig = AllpassL.ar( // the delay (you could use AllpassC (put 0 in decay))
		input + (local * fdbk),
		maxdelay * 2,
		LFPar.kr( // very similar to SinOsc (try to replace it) - Even use LFTri
			rate * maxrate,
			0,
			depth * maxdelay,
			delay * maxdelay),
		decay);
	mixed = input + dsig;
	LocalOut.ar(mixed);
	Out.ar([out, out+1], mixed);

}).send(s);
)

b = Bus.audio(s,1);

(
r = Synth.new(\reverb, [\inBus, b]);
e = Synth.new(\dubecho, [\inBus, b]);
t = Synth.before(r, \tone, [\freq, 440,\effectBus, b]);
w = Synth.before(r, \water, [\effectBus, b]);
)

w.set(\fund, 200);
w.set(\speed, 20);

