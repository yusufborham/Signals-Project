classdef buildingSignal < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        doneButton                     matlab.ui.control.Button
        ChooseSignalTypeDropDown       matlab.ui.control.DropDown
        ChooseSignalTypeDropDownLabel  matlab.ui.control.Label
    end

    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: ChooseSignalTypeDropDown
        function ChooseSignalTypeDropDownValueChanged(app, event)
           % Update the output value when the dropdown value changes
            value = app.ChooseSignalTypeDropDown.Value;
            assignin('base',"result",value)
            
        end

        % Button pushed function: doneButton
        function doneButtonPushed(app, event)

            delete(app);  % Close the window
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 308 115];
            app.UIFigure.Name = 'MATLAB App';

            % Create ChooseSignalTypeDropDownLabel
            app.ChooseSignalTypeDropDownLabel = uilabel(app.UIFigure);
            app.ChooseSignalTypeDropDownLabel.HorizontalAlignment = 'right';
            app.ChooseSignalTypeDropDownLabel.Position = [11 29 112 22];
            app.ChooseSignalTypeDropDownLabel.Text = 'Choose Signal Type';

            % Create ChooseSignalTypeDropDown
            app.ChooseSignalTypeDropDown = uidropdown(app.UIFigure);
            app.ChooseSignalTypeDropDown.Items = {'DC', 'Ramp', 'Polynomial', 'Exponential', 'Sinusoidal', 'choose'};
            app.ChooseSignalTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ChooseSignalTypeDropDownValueChanged, true);
            app.ChooseSignalTypeDropDown.Position = [138 29 100 22];
            app.ChooseSignalTypeDropDown.Value = 'choose';

            % Create doneButton
            app.doneButton = uibutton(app.UIFigure, 'push');
            app.doneButton.ButtonPushedFcn = createCallbackFcn(app, @doneButtonPushed, true);
            app.doneButton.Position = [237 8 62 22];
            app.doneButton.Text = 'done';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = buildingSignal

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