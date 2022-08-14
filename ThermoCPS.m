clear; close all; clc
thermoSys = NetworkThermostat();

x0 = [0, 0, 0, 0, 0];
tspan = [0, 15];
jspan = [0, 9999999];
config = HybridSolverConfig('refine', 32); % Improves plot smoothness.
sol = thermoSys.solve(x0, tspan, jspan, config);
%plotFlows(sol);

x = sol.x;
t = sol.t;

T   = x(:,1);
t_T     = x(:,2);
q  = x(:,3);
t_q = x(:,4);
m_q       = x(:,5);

figure(2)
subplot(4, 1, 1)
hold on
plot(t, T)
plot(tspan, [thermoSys.T_min thermoSys.T_min], "--b")
plot(tspan, [thermoSys.T_max thermoSys.T_max], "--r")
ylabel("Temperature")

subplot(4, 1, 2)
plot(t, q)
axis([tspan, -0.5, 1.5])
ylabel("State (q)")

subplot(4, 1, 3)
plot(t, t_T)
ylabel("Timer (\tau_s)")


subplot(4, 1, 4)
plot(t, t_q)
ylabel("Timer (\tau_h)")
xlabel("time")





