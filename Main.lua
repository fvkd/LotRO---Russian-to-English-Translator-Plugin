import "Turbine";
import "Turbine.Chat";
import "Turbine.UI";
import "Turbine.UI.Lotro";

RussianToEnglishTranslator = class(Turbine.UI.Window);

function RussianToEnglishTranslator:Constructor()
    Turbine.UI.Window.Constructor(self);

    -- Initialize the chat listener
    self.chatListener = Turbine.Chat.ReceivedEventArgs;
    Turbine.Chat.Received = function(sender, args)
        self:OnChatReceived(args);
    end
end

function RussianToEnglishTranslator:OnChatReceived(args)
    local message = args.Message;
    local sender = args.Sender;

    -- Detect if the message is in Russian
    if self:IsRussian(message) then
        -- Translate the message
        local translatedMessage = self:TranslateToEnglish(message);

        -- Output the translated message
        Turbine.Shell.WriteLine("[Translated] " .. sender .. ": " .. translatedMessage);
    end
end

function RussianToEnglishTranslator:IsRussian(text)
    return string.match(text, "[\208-\209][\128-\191]") ~= nil;
end

function RussianToEnglishTranslator:TranslateToEnglish(text)
    local apiKey = "YOUR_GOOGLE_TRANSLATE_API_KEY"; -- Replace with your API key
    local url = "https://translation.googleapis.com/language/translate/v2?key=" .. apiKey .. "&q=" .. Turbine.Network.EncodeUrl(text) .. "&target=en";

    local request = Turbine.Network.HttpRequest(url);
    request:Send();

    local response = request:Receive();
    local result = Turbine.Network.DecodeUrl(response);

    -- Extract the translated text from the result
    local translatedText = string.match(result, "\"translatedText\":\"(.-)\"");

    return translatedText or "Translation failed";
end

translator = RussianToEnglishTranslator();
