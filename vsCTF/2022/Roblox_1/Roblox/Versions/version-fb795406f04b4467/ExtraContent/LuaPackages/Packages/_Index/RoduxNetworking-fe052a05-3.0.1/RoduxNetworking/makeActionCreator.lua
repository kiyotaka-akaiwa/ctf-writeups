local root = script.Parent
local Action = require(root.Action)

return function(networkRequestScript)
	return {
		Succeeded = Action(networkRequestScript.Name .. "_Succeeded", function(ids, responseBody, namedIds, requestOptions, additionalData)
			return {
				ids = ids,
				responseBody = responseBody,
				namedIds = namedIds,
				postBody = requestOptions and requestOptions.postBody or nil,
				queryArgs = requestOptions and requestOptions.queryArgs,
				additionalData = additionalData,
			}
		end),
		Failed = Action(networkRequestScript.Name .. "_Failed", function(ids, error, namedIds, requestOptions, additionalData)
			return {
				ids = ids,
				error = error,
				namedIds = namedIds,
				postBody = requestOptions and requestOptions.postBody or nil,
				queryArgs = requestOptions and requestOptions.queryArgs or nil,
				additionalData = additionalData,
			}
		end),
	}
end
