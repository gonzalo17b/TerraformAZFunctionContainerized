using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using POCAZfuncion.ServiceBus;

namespace POCAZfuncion
{
    public static class Audit
    {
        [FunctionName("audit")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequest req,
            ILogger log,
            ExecutionContext context)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var config = BuildConfiguration(context.FunctionAppDirectory);

            QueueHelper.ListenToQueue(config, log);

            return new OkObjectResult(
                "Hi, I'm already up and running listening to the service bus." +
                " Every time I receive a message I will send it to the ORC service bus.");
        }

        private static IConfigurationRoot BuildConfiguration(string functionAppDirectory)
        {
            var configBuilder = new ConfigurationBuilder()
                .SetBasePath(functionAppDirectory)
                .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables();

            return configBuilder.Build();
        }
    }
}
