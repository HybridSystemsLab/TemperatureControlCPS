classdef NetworkThermostat < HybridSystem
    
    properties
        % Temperature
        T_delta = 100
        T_max   = 80
        T_min   = 70
        a       = 1
        
        % Time
        t_min   = 1
        t_max   = .1
    end
    
    methods
        
        function this = NetworkThermostat()
            state_dim = 5;
            this = this@HybridSystem(state_dim);
        end
        
        %Physical System
        function xdot = flowMap(this, x, t ,j)
            T       = x(1);
            t_s     = x(2);
            q       = x(3);
            t_h     = x(4);
            m_h     = x(5);

            
            xdot = [
                this.a*(-T + m_h*this.T_delta)
                -1
                0
                -1
                0
            ];
        end
        
        %Cyber State Machine
        function xplus = jumpMap(this, x)
            T       = x(1);
            t_s   = x(2);
            q       = x(3);
            t_h   = x(4);
            m_h     = x(5);
            
            %This handles the case that both timers reset
            %simultaneously
            if (t_s <= 0) && (t_h <= 0)
                xplus = [
                  T
                  this.t_min + (this.t_max - this.t_min)*rand()
                  this.G(q, T)
                  this.t_min + (this.t_max - this.t_min)*rand()
                  q
                ];
            elseif t_s <= 0
                xplus = [
                    T
                    this.t_min + (this.t_max - this.t_min)*rand()
                    this.G(q, T)
                    t_h
                    m_h
                ];
            elseif t_h <= 0
                xplus = [
                    T
                    t_s
                    q
                    this.t_min + (this.t_max - this.t_min)*rand()
                    q
                ];
            end
        end
        
        function qplus = G(this, q, T)
            if (T <= this.T_min && q == 0) || ...
                    (T >= this.T_max && q == 1)
                qplus = 1 - q;
            else
                qplus = q;
            end
        end
        
        function C = flowSetIndicator(this, x)
            t_s     = x(2);
            t_h     = x(4);
            
            C = t_s > 0 && t_h > 0;
        end
        
        function D = jumpSetIndicator(this, x)
            t_s     = x(2);
            t_h     = x(4);
            
            D = t_s <= 0 || t_h <= 0;
        end
    end
end