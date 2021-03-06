describe Travis::API::V3::Services::Repository::Find, set_app: true do
  let(:repo)  { Travis::API::V3::Models::Repository.where(owner_name: 'svenfuchs', name: 'minimal').first }
  let(:build) { repo.builds.first }
  let(:jobs)  { Travis::API::V3::Models::Build.find(build.id).jobs }
  before { repo.default_branch.save! }

  describe "public repository, existing branch" do
    before     { get("/v3/repo/#{repo.id}/branch/master") }
    example    { expect(last_response).to be_ok           }
    example    { expect(JSON.load(body)).to be == {
      "@type"            => "branch",
      "@href"            => "/v3/repo/#{repo.id}/branch/master",
      "@representation"  => "standard",
      "name"             => "master",
      "default_branch"   => true,
      "exists_on_github" => true,
      "repository"       => {
        "@type"          => "repository",
        "@href"          => "/v3/repo/#{repo.id}",
        "@representation"=> "minimal",
        "id"             => repo.id,
        "name"           => "minimal",
        "slug"           => "svenfuchs/minimal"},
      "last_build"       => {
        "@type"          => "build",
        "@href"          => "/v3/build/#{build.id}",
        "@representation"=> "minimal",
        "id"             => build.id,
        "number"         => build.number,
        "state"          => build.state,
        "duration"       => nil,
        "event_type"     => "push",
        "previous_state" => "passed",
        "started_at"     => "2010-11-12T13:00:00Z",
        "finished_at"    => nil }}}
  end
end
