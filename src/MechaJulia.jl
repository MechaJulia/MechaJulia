
module MechaJulia
import Requests
import JSON

const auth_token = readall("../src/token")
const METADATA   = "IainNZ/METADATA.jl"

const MSG_VER000 = """
* It looks like you are adding a version 0.0.0, but this is discouraged.
  Consider tagging a "real" first version like 0.0.1 or, if you feel the
  package is not ready, encourage testers to obtain it with `Pkg.clone`"""

function is_there_ver000(file_list)
    """
    Given a list of files parsed from the JSON return from
      GET /repos/:owner/:repo/pulls/:number/files
      https://developer.github.com/v3/pulls/#list-pull-requests-files
    look for a new 0.0.0 version being added (which is discouraged).
    """
    for file in file_list
        # Only look at added files, anything else probably is either
        # tidy up or a fix to a wrong SHA
        file["status"] != "added" && continue

        if contains(file["filename"], "versions/0.0.0")
            return true, " * It looks like you are adding a version 0.0.0"
    end


function check_pr_ok()
    url = "https://api.github.com/repos/$METADATA/pulls?access_token=$(auth_token)"
    #raw = Requests.get(url; json = {"sort" => "updated"})
    #prs = raw.data |> JSON.parse
    #fp = open(METADATA[1:4],"w")
    #println(fp,raw.data)
    #close(fp)
    prs = readall(METADATA[1:4]) |> JSON.parse
    for pr in prs
        println(pr["title"])
        println(pr["number"])
        println(pr["_links"]["issue"]["href"])

        # Look at files being committed
        number = int(pr["number"])
        url    = "https://api.github.com/repos/$METADATA/pulls/$number/files?access_token=$(auth_token)"
        raw    = Requests.get(url)
        files  = raw.data |> JSON.parse

    end
end

end