# snippet-sourcedescription:[ ]
# snippet-service:[dynamodb]
# snippet-keyword:[Ruby]
# snippet-sourcesyntax:[ruby]
# snippet-keyword:[Amazon DynamoDB]
# snippet-keyword:[Code Sample]
# snippet-keyword:[ ]
# snippet-sourcetype:[full-example]
# snippet-sourcedate:[ ]
# snippet-sourceauthor:[AWS]
# snippet-start:[dynamodb.Ruby.CodeExample.MoviesScan] 

#
#  Copyright 2010-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#  This file is licensed under the Apache License, Version 2.0 (the "License").
#  You may not use this file except in compliance with the License. A copy of
#  the License is located at
# 
#  http://aws.amazon.com/apache2.0/
# 
#  This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied. See the License for the
#  specific language governing permissions and limitations under the License.
#
require "aws-sdk"

Aws.config.update({
  region: "us-west-2",
  endpoint: "http://localhost:8000"
})

dynamodb = Aws::DynamoDB::Client.new

table_name = "Movies"

params = {
    table_name: table_name,
    projection_expression: "#yr, title, info.rating",
    filter_expression: "#yr between :start_yr and :end_yr",
    expression_attribute_names: {"#yr"=> "year"},
    expression_attribute_values: {
        ":start_yr" => 1950,
        ":end_yr" => 1959
    }
}

puts "Scanning Movies table."

begin
    loop do
        result = dynamodb.scan(params)

        result.items.each{|movie|
            puts "#{movie["year"].to_i}: " +
                "#{movie["title"]} ... " + 
                "#{movie["info"]["rating"].to_f}"
        }
        
        break if result.last_evaluated_key.nil?

        puts "Scanning for more..."
        params[:exclusive_start_key] = result.last_evaluated_key
    end
    
rescue  Aws::DynamoDB::Errors::ServiceError => error
    puts "Unable to scan:"
    puts "#{error.message}"
end
# snippet-end:[dynamodb.Ruby.CodeExample.MoviesScan]