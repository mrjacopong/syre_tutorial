%% Use case motor Parameters (this is an example)
% These will be converted into Syre-compatible parameters in the next section.

% % requirements
req.poles=8;             % number of poles 2*p
ini.d0=1/1000;           % Airgap thickness
ini.Ns=48;               % Stator slots

% % stator lamination (all quantities are in [m])
lamS.Dext=195e-3;        % external diameter
lamS.D=126e-3;           % Internal diameter
lamS.hy=11e-3;           % Yoke height
lamS.Ns=ini.Ns;          % Slot number
lamS.wt=5e-3;            % Tooth width
lamS.so=2e-3;            % slot opening width
lamS.h4=2.0e-3;          % slot opening height
lamS.h3_p_h4=3.5e-3;     % slot opening height plus wedge height
lamS.p=req.poles/2;      % number of pole pairs
lamS.L=100e-3;           % active length


% % rotor magnets (all quantities are in [m])
magnetsR.lMag=3.5e-3;    % magnet thickness
magnetsR.am=0.628;       % magnet pitch in mechanical radians
windings.qsh= 0;         % winding shortening of each coil (in number of slots)
windings.n_eq= 10;       % number of equivalent series conductors per slot
windings.parallels= 1;   % number of parallel paths
windings.n=windings.n_eq*windings.parallels; %


%% GUI_syre parameters
% Main Data(all quantities are in [mm])
syre.pp = lamS.p;
syre.ph_set = 1;
syre.N_spph = 2;
syre.N_ss = ini.Ns;
syre.Airgap_th = ini.d0*1e3;
syre.out_radi = lamS.Dext/2*1e3;
syre.airg_radi = lamS.D/2*1e3;
syre.shaft_radi = 99.0/2;
syre.stack_len = lamS.L*1e3;
syre.motor_type = "SPM";

% Stator
pole_pitch = rad2deg(2*pi/(syre.N_spph*syre.pp)); % useful later

syre.tooth_len = (lamS.Dext-lamS.D-lamS.hy*2)/2*1e3;
syre.tooth_wt = lamS.wt*1e3;
% syre.ss_op_PU = ?? -> It will be calculated later in the script. Once you have run the entire script,  you can evaluate the variable.
syre.tooth_tan_dep = lamS.h4*1e3;
% syre.tooth_tan_ang = ?? TODO -> it will be calculated later in the script. Same as before
syre.fillet_s_bot = 0.4; % adjust as needed

syre.s_ff = 0.4; % proj. parameter
syre.turns_p_s_p_ph = ini.Ns*windings.n_eq/3/2; % = N/2 = 2*n*p*q/2/2
syre.pitch_short = windings.qsh+1;
syre.liner_thick = 0; % adj as needed
% syre.n_sim_slot = -- ; No need to change it

% Rotor
% syre.barrier_angle_PU = -- ; No need to change it
syre.barrier_angle_deg = rad2deg(magnetsR.am);
% syre.barrier_width_PU= -- ; No need to change it
syre.barrier_width_mm = magnetsR.lMag*1e3;
syre.barrier_offset = 1; % increase it for more accurate simulation, but there is no need
syre.inner_radial_shift = 3.5; % ?? -> default
syre.outer_branch_shift = 1; % ?? -> default
syre.PM_shape_fact = 1 ; % adjust as needed

% Options
syre.curr_density = 5.5;% adjust as needed
% all other parameters are automatically updated by Syre
% you can play and see thermal parameters of the motor

% Materials
% you can use whatever you like, or add yours to the library
% suggested:
syre.stator_core="M250-35A"; % or M330-50A for industrial
stator_slot="Copper";
rotor_core="M250-35A"; % or M330-50A for industrial
flux_barrier="N33SH"; % N40EH more performance
rotor_slot="Aluminium";
shaft="air";
sleeve="DW235";


%% Calculation of parameters that needs some more math.
% It will be done here because it takes some lines of code.

%%%%%%%%%%%%%% START syre.ss_op_PU %%%%%%%%%%%%%%
% faccio i calcoli trigonometrici
syms r alpha
B = r * sind(alpha);
r2 = r-(r*cosd(alpha));
C = sqrt(B^2+r2^2);

% valuto alpha conoscendo R e C
r_val = syre.airg_radi; % radius
C_val = lamS.so*1e3; % slot opening
eq_with_alpha = subs(C, r, r_val);

alpha_sol = solve(eq_with_alpha == C_val , alpha);
alpha_sol = double(alpha_sol);

% acs = slot opening [pu]

alpha_slot = pole_pitch/(3*2*syre.ph_set); % angolo di passo cava

acs = alpha_sol/alpha_slot;

syre.ss_op_PU = acs(acs>0); % only positive value

%%%%%%%%%%%%%% END syre.ss_op_PU %%%%%%%%%%%%%%
 
%%%%%%%%%%%%%% START syre.tooth_tan_ang %%%%%%%%%%%%%%
% syre.tooth_tan_ang

syms r alpha
B = r * sind(alpha);
r2 = r-(r*cosd(alpha));
C = sqrt(B^2+r2^2);


r_val = syre.airg_radi+lamS.h3_p_h4*1e3; % radius
alpha_val = alpha_slot; % slot opening

slot_opening_at_h3 = double(subs(C, {r,alpha}, {r_val,alpha_val}))-syre.tooth_wt;


Lmaggiore = slot_opening_at_h3;
Lminore = lamS.so*1e3;
altezza = lamS.h3_p_h4*1e3-lamS.h4*1e3;

P = (Lmaggiore - Lminore) / 2;
beta_rad = atand(altezza / P);

syre.tooth_tan_ang = beta_rad;
%%%%%%%%%%%%%% END syre.tooth_tan_ang %%%%%%%%%%%%%%

fprintf("\n Now you are ready to copy and paste each parameter into GUI_Syre!\n")


%% Demagnetization current evaluation
% Magnet N33SH
Hcl = 1035e3;                       % datasheet @140degC
mu0=4*pi*1e-7;                      % standard
mud = 1.05*mu0;                     % datasheet
Br = 0.951;                         % datasheet
Lmagn = syre.barrier_width_mm*1e-3; % conv to m
delta0 = syre.Airgap_th*1e-3;       % conv to m
N = syre.turns_p_s_p_ph*2;          % Series conductors per phase
p = syre.pp;                        % pole pairs
factor = [0.8,0.9];                 % correction factor

% Formula for minimun magnet thickness
% Lmin = (N*Imax_pk/(2*syre.pp)+delta0/mu0*Br)/(factor*Hcl)-mud/mu0*delta0

% Reversed Lmin formula
Imax_pk_calc=((Lmagn+mud*delta0/mu0).*factor.*Hcl-delta0/mu0*Br)*2*p/N;
Imax_rms_calc = Imax_pk_calc/sqrt(2);

fprintf(" The max peak current before demagnetizing the magnet is in the range of [%.0f;%.0f] Apk\n\n", Imax_pk_calc)

%% Jacopo Ferretti, 2026