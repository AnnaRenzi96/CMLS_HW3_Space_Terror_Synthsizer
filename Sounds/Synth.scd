s.boot()

// Sounds


(
SynthDef.new(\yaw, {
	// fund
	// evaluate the function 6 times
	arg outBus = 0, effectBus, direction = 0.5, fund = 800;
    var n = 6, out;
    out = Mix.fill(
        n,
        {
			SinOsc.ar([fund, 67.rrand(1000)], 0, n.reciprocal * 0.1);
        }
    )*EnvGen.kr(Env.perc(0.5, 1), doneAction: Done.freeSelf);

	// Output
	Out.ar(outBus, Pan2.ar(out*direction));
	// Effect
	Out.ar(effectBus, Pan2.ar(out*(1-direction)));
}
).send(s);
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
	arg outBus = 0, effectBus, direction = 0.5, pan= 0, freq= 400, amp= 0.1;
	var amps= [1, 0.67, 1, 1.8, 2.67, 1.67];
	var dets= [0, 1, 0, 1.7, 0, 0];    // Detune
	// Mix.fill(n,function) n= size of array to create, function: array filling function
	var src= Mix.fill(6, {
		arg i;
		var env = EnvGen.ar(Env.asr);
		LFTri.ar(freq*i/4 + dets[i], 0, amp*env);
	});

	// Output
	Out.ar(outBus, Pan2.ar(src*direction, pan));
	// Effect
	Out.ar(effectBus, Pan2.ar(src*(1-direction), pan));

}).send(s);
)

(
SynthDef.new(\blipblop, {
	arg outBus = 0, effectBus, direction = 0.5, period = 0.05, mille = 2000;
	// we control period and mille
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

	Out.ar(outBus, Pan2.ar(sig*direction, pos:0));
	// Effect
	Out.ar(outBus, Pan2.ar(sig*(1-direction), pos:0));
}
).send(s);
)


//

// Effects

(
SynthDef(\reverb,{
	arg outBus = 0, flangerBus, inBus, dir = 0.5;
	var input;

	input = In.ar(inBus, 1);
	16.do({input = AllpassC.ar(in:input, maxdelaytime:0.04, delaytime:{Rand(0.001,0.04)}.dup, decaytime:3)});

	// Reverb
	Out.ar(outBus, input*dir);
	// to Flanger
	Out.ar(flangerBus, input*(1-dir));

}).send(s);
)

(
SynthDef(\flanger, {
	arg flangefreq=0.1, fdback=0.1, inBus;
	var input, effect;

	input=In.ar(inBus,2); //get two channels of input starting (and ending)
	input= input+ LocalIn.ar(2); //add some feedback
	effect= DelayN.ar(input,0.02,SinOsc.kr(flangefreq,0,0.005,0.005)); //max delay of 20msec
	LocalOut.ar(fdback*effect);
	Out.ar(0, effect); //adds to bus 0 where original signal is already playing

}).send(s);
)


// Connecting

~myBus = Bus.audio(s,1);



(

// direction direzione dai Synth sounds all'output senza effetti
// dir direzione al reverb
// 1-dir direzione dal reverb al flanger


~myReverb = Synth.new(\reverb, [\inBus, ~myBus, \dir, 1]);
~myFlanger = Synth.new(\flanger, [\inBus, ~myBus]);

//Yaw
~myYaw = Synth.before(~myReverb, \yaw, [\effectBus, ~myBus, \direction, 1]);

//Water
~myWater = Synth.before(~myReverb, \water, [\effectBus, ~myBus, \direction, 0]);


)



