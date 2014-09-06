
module MechaJulia
import Requests
import JSON

const auth_token = readall("../src/token")
const METADATA   = "IainNZ/METADATA.jl"

const MECHAJULIA_HEAD = """
*This is an automatic message from [MechaJulia](https://github.com/MechaJulia/MechaJulia),
a Julia bot that aims to help maintain Julia and its package ecosystem. If you think there
is something wrong with this message, or have ideas for a new feature, please 
[file an issue](https://github.com/MechaJulia/MechaJulia/issues/new)*

---
"""

const MSG_VER000 = """
* It looks like you are adding a version 0.0.0, but this is discouraged.
  Consider tagging a "real" first version like 0.0.1 or, if you feel the
  package is not ready, encourage testers to obtain it with `Pkg.clone`"""

function is_there_ver000(file_list)
    """
    Given a list of files parsed from the JSON response from
      GET /repos/:owner/:repo/pulls/:number/files
      https://developer.github.com/v3/pulls/#list-pull-requests-files
    look for a new 0.0.0 version being added (which is discouraged).
    """
    for file in file_list
        # Only look at added files, anything else probably is either
        # tidy up or a fix to a wrong SHA
        file["status"] != "added" && continue

        if contains(file["filename"], "versions/0.0.0")
            return true
        end
    end
    return false
end

function does_require_match(file_list)
    """
    Given a list of files parsed from the JSON response from
      GET /repos/:owner/:repo/pulls/:number/files
      https://developer.github.com/v3/pulls/#list-pull-requests-files
    look for `requires` files, and cross-reference them with the REQUIRE
    file in the package itself
    """
    for file in file_list
        file["status"] == "deleted" && continue
        !contains(file["filename"])


function check_pr_ok()
    # Pull all pull requests
    # GET /repos/:owner/:repo/pulls
    # https://developer.github.com/v3/pulls/#list-pull-requests
    url = "https://api.github.com/repos/$METADATA/pulls?access_token=$(auth_token)"
    raw = Requests.get(url; json = {"sort" => "updated"})
    prs = raw.data |> JSON.parse

    # Walk through them all looking for things to comment on that we haven't already
    for pr in prs
        println(pr["title"])
        println(pr["number"])
        println(pr["_links"]["issue"]["href"])

        message = MECHAJULIA_HEAD

        # Look at files being committed
        number = int(pr["number"])
        url    = "https://api.github.com/repos/$METADATA/pulls/$number/files?access_token=$(auth_token)"
        raw    = Requests.get(url)
        files  = raw.data |> JSON.parse
        if is_there_ver000(files)
            message *= MSG_VER000
        end

        println(message)
    end
end

end