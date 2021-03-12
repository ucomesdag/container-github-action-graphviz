#!/bin/sh

this_role=$(cat meta/main.yml | shyaml get-value galaxy_info.role_name)
this_namespace=$(cat meta/main.yml | shyaml get-value galaxy_info.namespace)
output_file=requirements.dot

cat << EOF > "${output_file}"
graph {

  node [margin="0.05,0.09" height=0 width=0 shape=box fontname="Sans serif" fontsize="9.5"];

  fontsize="8.5";
  fontname="Sans serif";

  label="ansible role depencencies";

  layout=dot;
  splines=compound;
  concentrate=true;
  center=treu;
  dpi=300;

  {
    "${this_role}"
EOF

if [ ! -f requirements.yml ] || grep -q '\[\s*\]' requirements.yml 2>/dev/null; then
  echo "    \"none\" [shape=plaintext] " >> "${output_file}"
  echo "  }" >> "${output_file}"
  echo "  \"${this_role}\" -- \"none\"" >> "${output_file}"
  echo "}" >> "${output_file}"
  exit
fi

cat requirements.yml | shyaml get-value roles | while read dash name role rest ; do
  if [[ ${role} =~ ${this_namespace}.* ]] ; then
    echo "    \"${role}\"  " >> "${output_file}"
  else
    echo "    \"${role}\" [style=filled fillcolor=grey85] " >> "${output_file}"
  fi
done

echo "  }" >> "${output_file}"

cat requirements.yml | shyaml get-value roles | while read dash name role rest ; do
  echo "  \"${this_role}\" -- \"${role}\"" >> "${output_file}"
done

echo "}" >> "${output_file}"
