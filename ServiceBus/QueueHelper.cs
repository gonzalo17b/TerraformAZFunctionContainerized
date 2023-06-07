using Azure.Messaging.ServiceBus;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using POCAZfuncion.Settings;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace POCAZfuncion.ServiceBus
{
    public static class QueueHelper
    {
        public static async Task ListenToQueue(IConfigurationRoot config, ILogger log, CancellationToken cancellationToken = default)
        {
            var serviceBusConfig = config.GetSection("ServiceBusConfiguration").Get<ServiceBusConfiguration>();
            await using ServiceBusClient client = new(serviceBusConfig.ConnectionString);

            var sessionProcessorOptions = new ServiceBusSessionProcessorOptions { MaxConcurrentSessions = 10 };
            var sessionProcessor = client.CreateSessionProcessor(serviceBusConfig.QueueName, sessionProcessorOptions);

            sessionProcessor.ProcessMessageAsync += async args =>
            {
                await ProcessMessageHandler(args, log, config);
            };

            sessionProcessor.ProcessErrorAsync += ProcessErrorHandler;

            log.LogInformation("Starting session processor...");

            await sessionProcessor.StartProcessingAsync(cancellationToken);

            while (!cancellationToken.IsCancellationRequested)
            {
                await Task.Delay(TimeSpan.FromSeconds(1), cancellationToken);
            }
            await sessionProcessor.StopProcessingAsync(cancellationToken);
        }

        private static async Task ProcessMessageHandler(ProcessSessionMessageEventArgs args, ILogger log, IConfigurationRoot config)
        {
            ServiceBusReceivedMessage message = args.Message;

            try
            {
                string messageBody = message.Body.ToString();
                log.LogInformation($"Received message: {messageBody}");
                await args.CompleteMessageAsync(message);

                await ExecuteMethodOnMessageReceived(log, config);
            }
            catch (Exception ex)
            {
                log.LogError($"Error processing message: {ex.Message}");
                await args.AbandonMessageAsync(message);
            }
        }

        private static async Task ExecuteMethodOnMessageReceived(ILogger log, IConfigurationRoot config)
        {
            var serviceBusConfig = config.GetSection("ServiceBusConfiguration").Get<ServiceBusConfiguration>();
            var sessionId = Guid.NewGuid().ToString();
            await using (ServiceBusClient client = new ServiceBusClient(serviceBusConfig.ExternalConnectionString))
            {
                ServiceBusSender sender = client.CreateSender(serviceBusConfig.ExternalQueueName);
                ServiceBusMessage message = new($"Hi from AzureFunction {DateTime.Now.ToShortDateString()}") { SessionId = sessionId };

                log.LogInformation("Sending...........");

                await sender.SendMessageAsync(message);

                log.LogInformation("Message sent to Azure Service Bus.");
            }
        }

        private static Task ProcessErrorHandler(ProcessErrorEventArgs args)
        {
            Console.WriteLine($"Error processing session: {args.Exception}");
            return Task.CompletedTask;
        }
    }
}
