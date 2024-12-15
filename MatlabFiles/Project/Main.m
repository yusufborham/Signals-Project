classdef projectApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure    matlab.ui.Figure
        Panel       matlab.ui.container.Panel
        editButton  matlab.ui.control.Button
        DrawButton  matlab.ui.control.Button
        UIAxes      matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        function DCsignal(app,startTime,endTime,Amp,samplingFreq)
            t = linspace(startTime , endTime , samplingFreq*(endTime-startTime)) ;
            y = Amp*ones(1,samplingFreq*(endTime-startTime)) ;
            plot(app.UIAxes,t,y,"b") ;
            hold(app.UIAxes ,'on') ;
            oldvect = evalin('base','SignalVector') ;
            newVect = [oldvect , y];
            assignin('base',"SignalVector",newVect);
            % xlim(app.UIAxes, [startTime endTime]);
        end
        function Rampsignal(app,startTime,endTime,Amp,c,samplingFreq)
            t = linspace(startTime , endTime , samplingFreq*(endTime-startTime)) ;
            y = Amp*t + c ;
            plot(app.UIAxes,t,y,"b") ;
            hold(app.UIAxes ,'on') ;
            oldvect = evalin('base','SignalVector') ;
            newVect = [oldvect , y];
            assignin('base',"SignalVector",newVect);
            % xlim(app.UIAxes, [startTime endTime]);
        end
        function Exposignal(app,startTime,endTime,Amp,pow,samplingFreq)
            t = linspace(startTime , endTime , samplingFreq*(endTime-startTime)) ;
            y = Amp*exp(pow*t) ;
            plot(app.UIAxes,t,y,"b") ;
            hold(app.UIAxes ,'on') ;
            oldvect = evalin('base','SignalVector') ;
            newVect = [oldvect , y];
            assignin('base',"SignalVector",newVect);
            % xlim(app.UIAxes, [startTime endTime]);
        end
        function sinsignal(app,startTime,endTime,Amp,freq,phase,samplingFreq)
            t = linspace(startTime , endTime , samplingFreq*(endTime-startTime)) ;
            y = Amp*cos(freq*t+phase);
            plot(app.UIAxes,t,y,"b") ;
            hold(app.UIAxes ,'on') ;
            oldvect = evalin('base','SignalVector') ;
            newVect = [oldvect , y];
            assignin('base',"SignalVector",newVect);
            % xlim(app.UIAxes, [startTime endTime]);
        end
        function polysignal(app,startTime,endTime,Amp,pow,c,samplingFreq)
            t = linspace(startTime , endTime , samplingFreq*(endTime-startTime)) ;
            y = Amp*t.^pow + c;
            plot(app.UIAxes,t,y,"b") ;
            hold(app.UIAxes ,'on') ;
            oldvect = evalin('base','SignalVector') ;
            newVect = [oldvect , y];
            assignin('base',"SignalVector",newVect);
            % xlim(app.UIAxes, [startTime endTime]);
        end
        
        function amplituideScale(app,amp)
            hold(app.UIAxes ,'off') ;
            oldvect = evalin('base','SignalVector') ;
            oldvect = amp*oldvect;

            oldvectTime = evalin('base','SignalVectorTime') ;
            plot(app.UIAxes,oldvectTime,oldvect,"r") ;
            
            assignin('base',"SignalVector",oldvect);
            assignin('base',"SignalVectorTime",oldvectTime);

            
        end
        function  timeShift(app,value)
            hold(app.UIAxes ,'off') ;
            oldvect = evalin('base','SignalVector') ;
            oldvectTime = evalin('base','SignalVectorTime') ;
            oldvectTime= oldvectTime+value;
           
            plot(app.UIAxes,oldvectTime,oldvect,"r") ;
            
            assignin('base',"SignalVector",oldvect);
            assignin('base',"SignalVectorTime",oldvectTime);

            
        end
          function  timeReversal(app)
            hold(app.UIAxes ,'off') ;
            oldvect = evalin('base','SignalVector') ;
            oldvectTime = evalin('base','SignalVectorTime') ;
            oldvectTime= -oldvectTime;
           
            plot(app.UIAxes,oldvectTime,oldvect,"r") ;
            
            assignin('base',"SignalVector",oldvect);
            assignin('base',"SignalVectorTime",oldvectTime);

            
          end
           function  compress(app,value)
            hold(app.UIAxes ,'off') ;
            oldvect = evalin('base','SignalVector') ;
            oldvectTime = evalin('base','SignalVectorTime') ;
            oldvectTime= value*oldvectTime;
           
            plot(app.UIAxes,oldvectTime,oldvect,"r") ;
            
            assignin('base',"SignalVector",oldvect);
            assignin('base',"SignalVectorTime",oldvectTime);

            
           end
           function  expand(app,value)
            hold(app.UIAxes ,'off') ;
            oldvect = evalin('base','SignalVector') ;
            oldvectTime = evalin('base','SignalVectorTime') ;
            oldvectTime= value*oldvectTime;
           
            plot(app.UIAxes,oldvectTime,oldvect,"r") ;
            
            assignin('base',"SignalVector",oldvect);
            assignin('base',"SignalVectorTime",oldvectTime);

            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: DrawButton
        function DrawButtonPushed(app, event)
            dlgtitle = 'User Input';
            dims = [1 50]; % 1 line, 50 characters width
            definput = {''}; % Default input value

            prompt = {'Enter the sampling frequency of the signal'};
            sampling_freq = str2double(inputdlg(prompt, dlgtitle, dims, definput));

            prompt = {'Enter the start time of the signal'};
            start_time = str2double(inputdlg(prompt, dlgtitle, dims, definput));

            prompt = {'Enter the end time of the signal'};
            end_time = str2double(inputdlg(prompt, dlgtitle, dims, definput));

            allTime = linspace(start_time,end_time,(end_time-start_time)*sampling_freq)
            assignin('base',"SignalVectorTime",allTime);

            prompt = {'Enter the number of break points of the signal'};
            break_points_number = str2double(inputdlg(prompt, dlgtitle, dims, definput));

            prompt = {'Enter the break points of the signal (comma separated)'};
            break_points = inputdlg(prompt, dlgtitle, dims, definput);
            break_points_ints = str2double(split(break_points, ','))% Replace commas with space
            break_points_ints = [start_time break_points_ints' end_time]

            assignin('base',"SignalVector",0);
            
            counter = 1 ;

            while counter <= length(break_points_ints)-1 
                builder = buildingSignal();
                waitfor(builder) ;
                result = evalin('base','result') ;
                disp(result)
                
    
                if (strcmp(result,"DC"))
                    prompt = {'Enter the Amplitude'};
                    Amplitude = str2double(inputdlg(prompt, dlgtitle, dims, definput));
                    DCsignal(app,break_points_ints(counter) ,break_points_ints(counter+1),Amplitude,sampling_freq)
                elseif(strcmp(result,"Exponential"))
                    prompt = {'Enter the Amplitude'};
                    Amplitude = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    
                    prompt = {'Enter the exponent'};
                    Exponent = str2double(inputdlg(prompt, dlgtitle, dims, definput));

                    Exposignal(app,break_points_ints(counter) ,break_points_ints(counter+1),Amplitude,Exponent,sampling_freq);
                elseif(strcmp(result,"Sinusoidal"))
                    prompt = {'Enter the Amplitude'};
                    Amplitude = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    
                    prompt = {'Enter the frequency'};
                    frequency = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    
                    prompt = {'Enter the phase'};                
                    phase = str2double(inputdlg(prompt, dlgtitle, dims, definput));

                    sinsignal(app,break_points_ints(counter) ,break_points_ints(counter+1),Amplitude,frequency,phase,sampling_freq)
                elseif(strcmp(result,"Ramp"))
                     prompt = {'Enter the Slope'};
                     Slope = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    
                     prompt = {'Enter the intercept'};
                     intercept = str2double(inputdlg(prompt, dlgtitle, dims, definput));

                     Rampsignal(app,break_points_ints(counter) ,break_points_ints(counter+1),Slope ,intercept ,sampling_freq )
               elseif(strcmp(result,"Polynomial"))
                     prompt = {'Enter the power'};
                     power = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    
                     prompt = {'Enter the intercept'};
                     intercept = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    
                     prompt = {'Enter the Amplituide'};
                     Amplitude = str2double(inputdlg(prompt, dlgtitle, dims, definput));

                    polysignal(app,break_points_ints(counter) ,break_points_ints(counter+1),Amplitude,power,intercept,sampling_freq)
                end

            counter = counter + 1 ;
       
            end

        hold(app.UIAxes ,'off') ;
        oldvect = evalin('base','SignalVector') ;
        plot(app.UIAxes,allTime,oldvect(2:end),"r") ;
        assignin('base',"SignalVector",oldvect(2:end));


        end

        % Button pushed function: editButton
        function editButtonPushed(app, event)
            dlgtitle = 'User Input';
            dims = [1 50]; % 1 line, 50 characters width
            definput = {''}; % Default input value
            editWindow = editSignal();
            waitfor(editWindow);
            result = evalin('base','operation') ;
            disp(result);
            if(strcmp(result,"Amplituide Scaling"))
               prompt = {'Enter the Scale'};
               valueOfoperation = str2double(inputdlg(prompt, dlgtitle, dims, definput));
               amplituideScale(app,valueOfoperation);
            elseif(strcmp(result,"Time reversal"))
               timeReversal(app);
            elseif(strcmp(result,"Compression"))
                prompt = {'Enter the value'};
                valueOfoperation = str2double(inputdlg(prompt, dlgtitle, dims, definput));
            while valueOfoperation>1
              prompt = {'Enter value smaller than 1'};
              valueOfoperation = str2double(inputdlg(prompt, dlgtitle, dims, definput));
            end
             compress(app,valueOfoperation);
            elseif(strcmp(result,"Time shift"))
             prompt = {'Enter the value'};
            valueOfoperation = str2double(inputdlg(prompt, dlgtitle, dims, definput));
            timeShift(app,valueOfoperation);

            elseif(strcmp(result,"Expansion"))
             prompt = {'Enter the value'};
            valueOfoperation = str2double(inputdlg(prompt, dlgtitle, dims, definput));
            while valueOfoperation<1
            prompt = {'Enter value greater than 1'};
            valueOfoperation = str2double(inputdlg(prompt, dlgtitle, dims, definput));
            end
            expand(app,valueOfoperation);
            elseif(strcmp(result,"none"))
            end



        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Signal')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'f(t)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [16 169 589 274];

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Title = 'Panel';
            app.Panel.Position = [16 42 150 85];

            % Create DrawButton
            app.DrawButton = uibutton(app.Panel, 'push');
            app.DrawButton.ButtonPushedFcn = createCallbackFcn(app, @DrawButtonPushed, true);
            app.DrawButton.Position = [15 38 100 22];
            app.DrawButton.Text = 'Draw';

            % Create editButton
            app.editButton = uibutton(app.Panel, 'push');
            app.editButton.ButtonPushedFcn = createCallbackFcn(app, @editButtonPushed, true);
            app.editButton.Position = [16 4 100 22];
            app.editButton.Text = 'edit';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = projectApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end