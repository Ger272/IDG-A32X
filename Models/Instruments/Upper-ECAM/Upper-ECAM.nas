# A3XX Upper ECAM Canvas
# Joshua Davidson (it0uchpods)

#######################################
# Copyright (c) A3XX Development Team #
#######################################

var upperECAM_iae_eis2 = nil;
var upperECAM_display = nil;
setprop("/engines/engine[0]/epr-actual", 1);
setprop("/engines/engine[1]/epr-actual", 1);
setprop("/engines/engine[0]/egt-actual", 1);
setprop("/engines/engine[1]/egt-actual", 1);
setprop("/engines/engine[0]/fuel-flow_actual", 0);
setprop("/engines/engine[1]/fuel-flow_actual", 0);
setprop("/ECAM/Upper/EPR[0]", 0);
setprop("/ECAM/Upper/EPR[1]", 0);
setprop("/ECAM/Upper/EPRthr[0]", 0);
setprop("/ECAM/Upper/EPRthr[1]", 0);
setprop("/ECAM/Upper/EPRylim", 0);
setprop("/ECAM/Upper/EGT[0]", 0);
setprop("/ECAM/Upper/EGT[1]", 0);
setprop("/ECAM/Upper/N1[0]", 0);
setprop("/ECAM/Upper/N1[1]", 0);
setprop("/ECAM/Upper/N1thr[0]", 0);
setprop("/ECAM/Upper/N1thr[1]", 0);
setprop("/ECAM/Upper/N1ylim", 0);

var canvas_upperECAM_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {'font-mapper': font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		if (getprop("/systems/electrical/bus/ac1") >= 110 or getprop("/systems/electrical/bus/ac2") >= 110) {
			# Choose between CFM, IAE, and EIS versions
			upperECAM_iae_eis2.page.show();
		} else {
			upperECAM_iae_eis2.page.hide();
		}
		
		settimer(func me.update(), 0.02);
	},
	updateBase: func() {
		# FOB
		me["FOB-LBS"].setText(sprintf("%7.0f", getprop("/consumables/fuel/total-fuel-lbs")));
		
		# Left ECAM Messages
		me["ECAML1"].hide();
		me["ECAML2"].hide();
		me["ECAML3"].hide();
		me["ECAML4"].hide();
		me["ECAML5"].hide();
		me["ECAML6"].hide();
		me["ECAML7"].hide();
		me["ECAML8"].hide();
	},
};

var canvas_upperECAM_iae_eis2 = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_upperECAM_iae_eis2 , canvas_upperECAM_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["EPR1-needle","EPR1-thr","EPR1-ylim","EPR1","EPR1-box","EPR1-scale","EPR1-scalenum","EPR1-XX","EPR1-XX2","EGT1-needle","EGT1","EGT1-scale","EGT1-box","EGT1-scale2","EGT1-scaletick","EGT1-XX","N11-needle","N11-thr","N11-ylim","N11","N11-decpnt",
		"N11-decimal","N11-scale","N11-scale2","N11-scalenum","N11-XX","EPR2-needle","EPR2-thr","EPR2-ylim","EPR2","EPR2-box","EPR2-scale","EPR2-scalenum","EPR2-XX","EPR2-XX2","EGT2-needle","EGT2","EGT2-scale","EGT2-box","EGT2-scale2","EGT2-scaletick","EGT2-XX",
		"N12-needle","N12-thr","N12-ylim","N12","N12-decpnt","N12-decimal","N12-scale","N12-scale2","N12-scalenum","N12-XX","N21","N21-decpnt","N21-decimal","N21-XX","FF1","FF1-XX","N22","N22-decpnt","N22-decimal","N22-XX","FF2","FF2-XX",
		"FOB-LBS","ECAML1","ECAML2","ECAML3","ECAML4","ECAML5","ECAML6","ECAML7","ECAML8","FlapTxt","FlapDots","EPRLim-mode","EPRLim","EPRLim-XX","EPRLim-XX2"];
	},
	update: func() {
		# EPR
		me["EPR1"].setText(sprintf("%1.3f", getprop("/engines/engine[0]/epr-actual")));
		me["EPR2"].setText(sprintf("%1.3f", getprop("/engines/engine[1]/epr-actual")));
		
		me["EPR1-needle"].setRotation((getprop("/ECAM/Upper/EPR[0]") + 90)*D2R);
		me["EPR1-thr"].setRotation((getprop("/ECAM/Upper/EPRthr[0]") + 90)*D2R);
		me["EPR1-ylim"].setRotation((getprop("/ECAM/Upper/EPRylim") + 90)*D2R);
		me["EPR2-needle"].setRotation((getprop("/ECAM/Upper/EPR[1]") + 90)*D2R);
		me["EPR2-thr"].setRotation((getprop("/ECAM/Upper/EPRthr[1]") + 90)*D2R);
		me["EPR2-ylim"].setRotation((getprop("/ECAM/Upper/EPRylim") + 90)*D2R);
		
		if (getprop("/systems/fadec/eng1/epr") == 1) {
			me["EPR1-scale"].setColor(1,1,1);
			me["EPR1"].show();
			me["EPR1-needle"].show();
			me["EPR1-thr"].show();
			me["EPR1-ylim"].show();
			me["EPR1-scalenum"].show();
			me["EPR1-box"].show();
			me["EPR1-XX"].hide();
			me["EPR1-XX2"].hide();
		} else {
			me["EPR1-scale"].setColor(1,0.6,0);
			me["EPR1"].hide();
			me["EPR1-needle"].hide();
			me["EPR1-thr"].hide();
			me["EPR1-ylim"].hide();
			me["EPR1-scalenum"].hide();
			me["EPR1-box"].hide();
			me["EPR1-XX"].show();
			me["EPR1-XX2"].show();
		}
		
		if (getprop("/systems/fadec/eng2/epr") == 1) {
			me["EPR2-scale"].setColor(1,1,1);
			me["EPR2"].show();
			me["EPR2-needle"].show();
			me["EPR2-thr"].show();
			me["EPR2-ylim"].show();
			me["EPR2-scalenum"].show();
			me["EPR2-box"].show();
			me["EPR2-XX"].hide();
			me["EPR2-XX2"].hide();
		} else {
			me["EPR2-scale"].setColor(1,0.6,0);
			me["EPR2"].hide();
			me["EPR2-needle"].hide();
			me["EPR2-thr"].hide();
			me["EPR2-ylim"].hide();
			me["EPR2-scalenum"].hide();
			me["EPR2-box"].hide();
			me["EPR2-XX"].show();
			me["EPR2-XX2"].show();
		}
		
		# EGT
		me["EGT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/egt-actual"))));
		me["EGT2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/egt-actual"))));
		
		me["EGT1-needle"].setRotation((getprop("/ECAM/Upper/EGT[0]") + 90)*D2R);
		me["EGT2-needle"].setRotation((getprop("/ECAM/Upper/EGT[1]") + 90)*D2R);
		
		if (getprop("/systems/fadec/eng1/egt") == 1) {
			me["EGT1-scale"].setColor(1,1,1);
			me["EGT1-scale2"].setColor(1,0,0);
			me["EGT1"].show();
			me["EGT1-needle"].show();
			me["EGT1-scaletick"].show();
			me["EGT1-box"].show();
			me["EGT1-XX"].hide();
		} else {
			me["EGT1-scale"].setColor(1,0.6,0);
			me["EGT1-scale2"].setColor(1,0.6,0);
			me["EGT1"].hide();
			me["EGT1-needle"].hide();
			me["EGT1-scaletick"].hide();
			me["EGT1-box"].hide();
			me["EGT1-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/egt") == 1) {
			me["EGT2-scale"].setColor(1,1,1);
			me["EGT2-scale2"].setColor(1,0,0);
			me["EGT2"].show();
			me["EGT2-needle"].show();
			me["EGT2-scaletick"].show();
			me["EGT2-box"].show();
			me["EGT2-XX"].hide();
		} else {
			me["EGT2-scale"].setColor(1,0.6,0);
			me["EGT2-scale2"].setColor(1,0.6,0);
			me["EGT2"].hide();
			me["EGT2-needle"].hide();
			me["EGT2-scaletick"].hide();
			me["EGT2-box"].hide();
			me["EGT2-XX"].show();
		}
		
		# N1
		me["N11"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n1") + 0.05)));
		me["N11-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n1") + 0.05,1))));
		
		me["N12"].setText(sprintf("%s", math.floor(getprop("/engines/engine[1]/n1") + 0.05)));
		me["N12-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/n1") + 0.05,1))));
		
		me["N11-needle"].setRotation((getprop("/ECAM/Upper/N1[0]") + 90)*D2R);
		me["N11-thr"].setRotation((getprop("/ECAM/Upper/N1thr[0]") + 90)*D2R);
		me["N11-ylim"].setRotation((getprop("/ECAM/Upper/N1ylim") + 90)*D2R);
		
		me["N12-needle"].setRotation((getprop("/ECAM/Upper/N1[1]") + 90)*D2R);
		me["N12-thr"].setRotation((getprop("/ECAM/Upper/N1thr[1]") + 90)*D2R);
		me["N12-ylim"].setRotation((getprop("/ECAM/Upper/N1ylim") + 90)*D2R);
		
		if (getprop("/systems/fadec/eng1/n1") == 1) {
			me["N11-scale"].setColor(1,1,1);
			me["N11-scale2"].setColor(1,0,0);
			me["N11"].show();
			me["N11-decimal"].show();
			me["N11-decpnt"].show();
			me["N11-needle"].show();
			me["N11-scalenum"].show();
			me["N11-XX"].hide();
		} else {
			me["N11-scale"].setColor(1,0.6,0);
			me["N11-scale2"].setColor(1,0.6,0);
			me["N11"].hide();
			me["N11-decimal"].hide();
			me["N11-decpnt"].hide();
			me["N11-needle"].hide();
			me["N11-scalenum"].hide();
			me["N11-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/n1") == 1) {
			me["N12-scale"].setColor(1,1,1);
			me["N12-scale2"].setColor(1,0,0);
			me["N12"].show();
			me["N12-decimal"].show();
			me["N12-decpnt"].show();
			me["N12-needle"].show();
			me["N12-scalenum"].show();
			me["N12-XX"].hide();
		} else {
			me["N12-scale"].setColor(1,0.6,0);
			me["N12-scale2"].setColor(1,0.6,0);
			me["N12"].hide();
			me["N12-decimal"].hide();
			me["N12-decpnt"].hide();
			me["N12-needle"].hide();
			me["N12-scalenum"].hide();
			me["N12-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng1/n1") == 1 and getprop("/systems/fadec/n1mode1") == 1) {
			me["N11-thr"].show();
			me["N11-ylim"].hide(); # Keep it hidden, since N1 mode limit calculation is not done yet
		} else {
			me["N11-thr"].hide();
			me["N11-ylim"].hide();
		}
		
		if (getprop("/systems/fadec/eng1/n2") == 1 and getprop("/systems/fadec/n1mode2") == 1) {
			me["N12-thr"].show();
			me["N12-ylim"].hide(); # Keep it hidden, since N1 mode limit calculation is not done yet
		} else {
			me["N12-thr"].hide();
			me["N12-ylim"].hide();
		}
		
		# N2
		me["N21"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n2") + 0.05)));
		me["N21-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n2") + 0.05,1))));
		me["N22"].setText(sprintf("%s", math.floor(getprop("/engines/engine[1]/n2") + 0.05)));
		me["N22-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/n2") + 0.05,1))));
		
		if (getprop("/systems/fadec/eng1/n2") == 1) {
			me["N21"].show();
			me["N21-decimal"].show();
			me["N21-decpnt"].show();
			me["N21-XX"].hide();
		} else {
			me["N21"].hide();
			me["N21-decimal"].hide();
			me["N21-decpnt"].hide();
			me["N21-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/n2") == 1) {
			me["N22"].show();
			me["N22-decimal"].show();
			me["N22-decpnt"].show();
			me["N22-XX"].hide();
		} else {
			me["N22"].hide();
			me["N22-decimal"].hide();
			me["N22-decpnt"].hide();
			me["N22-XX"].show();
		}
		
		# FF
		me["FF1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/fuel-flow_actual"))));
		me["FF2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/fuel-flow_actual"))));
		
		if (getprop("/systems/fadec/eng1/ff") == 1) {
			me["FF1"].show();
			me["FF1-XX"].hide();
		} else {
			me["FF1"].hide();
			me["FF1-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/ff") == 1) {
			me["FF2"].show();
			me["FF2-XX"].hide();
		} else {
			me["FF2"].hide();
			me["FF2-XX"].show();
		}
		
		# EPR Limit
		me["EPRLim-mode"].setText(sprintf("%s", getprop("/controls/engines/thrust-limit")));
		me["EPRLim"].setText(sprintf("%1.3f", getprop("/controls/engines/epr-limit")));
		
		if (getprop("/systems/fadec/powered1") == 1 or getprop("/systems/fadec/powered2") == 1) {
			me["EPRLim-mode"].show();
			me["EPRLim"].show();
			me["EPRLim-XX"].hide();
			me["EPRLim-XX2"].hide();
		} else {
			me["EPRLim-mode"].hide();
			me["EPRLim"].hide();
			me["EPRLim-XX"].show();
			me["EPRLim-XX2"].show();
		}
		
		# Flap Indicator
		me["FlapTxt"].setText(sprintf("%s", getprop("/controls/flight/flap-txt")));
		
		if (getprop("/controls/flight/flap-pos") > 0) {
			me["FlapDots"].show();
		} else {
			me["FlapDots"].hide();
		}
		
		me.updateBase();
		
		settimer(func me.update(), 0.02);
	},
};

setlistener("sim/signals/fdm-initialized", func {
	upperECAM_display = canvas.new({
		"name": "upperECAM",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	upperECAM_display.addPlacement({"node": "uecam.screen"});
	var group_iae_eis2 = upperECAM_display.createGroup();

	upperECAM_iae_eis2 = canvas_upperECAM_iae_eis2.new(group_iae_eis2, "Aircraft/A320Family/Models/Instruments/Upper-ECAM/res/iae-eis2.svg");

	upperECAM_iae_eis2.update();
	canvas_upperECAM_base.update();
});

var showUpperECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(upperECAM_display);
}